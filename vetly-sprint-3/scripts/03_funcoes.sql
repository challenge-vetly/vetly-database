-- ============================================================================
-- SPRINT 3 - MASTERING RELATIONAL AND NON-RELATIONAL DATABASE
-- FUNCOES
-- ============================================================================

-- ============================================================================
-- PROCEDURE AUXILIAR (compartilhada por funcoes e procedures desta entrega):
-- registra em TB_LOG_ERRO cada excecao tratada, sem depender da transacao
-- chamadora (PRAGMA AUTONOMOUS_TRANSACTION) -- assim o log sobrevive mesmo
-- que a operacao original seja desfeita.
-- ============================================================================
CREATE OR REPLACE PROCEDURE SP_REGISTRA_LOG (
    p_nm_procedure  IN VARCHAR2,
    p_cd_erro       IN NUMBER,
    p_ds_mensagem   IN VARCHAR2
) AS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO TB_LOG_ERRO (
        ID_LOG, NM_PROCEDURE, NM_USUARIO, DT_OCORRENCIA, CD_ERRO, DS_MENSAGEM
    ) VALUES (
        SQ_LOG_ERRO.NEXTVAL, p_nm_procedure, USER, SYSDATE, p_cd_erro, p_ds_mensagem
    );
    COMMIT;
END SP_REGISTRA_LOG;
/

-- ============================================================================
-- FUNCAO 1: FN_MONTA_JSON_ANIMAL
--
-- Recebe dados relacionais ja obtidos de um JOIN (ANIMAL + ESPECIE + TUTOR +
-- PESSOA) e retorna manualmente uma string no formato JSON.
--
-- Nenhuma funcao pronta de JSON do Oracle e usada (nao ha TO_JSON, JSON_OBJECT,
-- JSON_VALUE, JSON_QUERY, JSON_TABLE nem similares). A montagem e feita por
-- concatenacao de string (||) e uma funcao auxiliar local (FN_ESCAPA_JSON, uma
-- subrotina aninhada) que escapa aspas/barras/quebras de linha caractere a
-- caractere -- a unica logica de "escape" e feita pelo grupo.
-- ============================================================================
CREATE OR REPLACE FUNCTION FN_MONTA_JSON_ANIMAL (
    p_id_animal    IN VARCHAR2,
    p_nm_animal    IN VARCHAR2,
    p_nm_especie   IN VARCHAR2,
    p_rc_animal    IN VARCHAR2,
    p_sx_animal    IN VARCHAR2,
    p_peso_animal  IN NUMBER,
    p_nm_tutor     IN VARCHAR2,
    p_tel_tutor    IN VARCHAR2
) RETURN VARCHAR2
AS
    -- Excecao de negocio: campo obrigatorio ausente
    e_campo_obrigatorio EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_campo_obrigatorio, -20001);

    v_json VARCHAR2(4000);

    -- Subrotina local: escapa manualmente os caracteres especiais do JSON
    -- (aspas duplas e barra invertida) percorrendo a string caractere a
    -- caractere -- sem usar nenhuma funcao pronta de JSON.
    FUNCTION FN_ESCAPA_JSON(p_valor IN VARCHAR2) RETURN VARCHAR2 IS
        v_saida VARCHAR2(4000) := '';
        v_char  CHAR(1);
    BEGIN
        IF p_valor IS NULL THEN
            RETURN '';
        END IF;

        FOR i IN 1 .. LENGTH(p_valor) LOOP
            v_char := SUBSTR(p_valor, i, 1);
            IF v_char = '"' THEN
                v_saida := v_saida || '\"';
            ELSIF v_char = '\' THEN
                v_saida := v_saida || '\\';
            ELSIF ASCII(v_char) = 10 THEN -- quebra de linha
                v_saida := v_saida || '\n';
            ELSE
                v_saida := v_saida || v_char;
            END IF;
        END LOOP;

        RETURN v_saida;
    END FN_ESCAPA_JSON;

BEGIN
    IF p_id_animal IS NULL OR p_nm_animal IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'FN_MONTA_JSON_ANIMAL: ID_ANIMAL e NM_ANIMAL sao obrigatorios');
    END IF;

    v_json := '{'
        || '"idAnimal":"'   || FN_ESCAPA_JSON(p_id_animal)  || '",'
        || '"nome":"'       || FN_ESCAPA_JSON(p_nm_animal)  || '",'
        || '"especie":"'    || FN_ESCAPA_JSON(p_nm_especie) || '",'
        || '"raca":"'       || FN_ESCAPA_JSON(p_rc_animal)  || '",'
        || '"sexo":"'       || FN_ESCAPA_JSON(p_sx_animal)  || '",'
        || '"pesoKg":'      || NVL(TO_CHAR(p_peso_animal, 'FM9999990.00'), 'null') || ','
        || '"tutor":{'
        ||     '"nome":"'   || FN_ESCAPA_JSON(p_nm_tutor)   || '",'
        ||     '"telefone":"' || FN_ESCAPA_JSON(p_tel_tutor) || '"'
        || '}'
        || '}';

    RETURN v_json;
EXCEPTION
    WHEN e_campo_obrigatorio THEN
        SP_REGISTRA_LOG('FN_MONTA_JSON_ANIMAL', SQLCODE, SQLERRM);
        RAISE;
    WHEN VALUE_ERROR THEN
        SP_REGISTRA_LOG('FN_MONTA_JSON_ANIMAL', SQLCODE, 'Erro de valor/tipo ao formatar peso: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('FN_MONTA_JSON_ANIMAL', SQLCODE, SQLERRM);
        RAISE;
END FN_MONTA_JSON_ANIMAL;
/

-- ============================================================================
-- FUNCAO 2: FN_VALIDA_CPF
--
-- Substitui o processo de validacao de CPF que hoje NAO existe antes de
-- gravar TB_PESSOA.CPF_PESSOA (SP_INS_PESSOA aceita qualquer VARCHAR2(11)).
-- Implementa o algoritmo oficial de digito verificador (modulo 11) usado
-- pela Receita Federal, retornando 'S' (valido) ou 'N' (invalido).
-- ============================================================================
CREATE OR REPLACE FUNCTION FN_VALIDA_CPF (
    p_cpf IN VARCHAR2
) RETURN CHAR
AS
    e_cpf_nulo             EXCEPTION;
    e_cpf_tamanho_invalido EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_cpf_nulo, -20011);
    PRAGMA EXCEPTION_INIT(e_cpf_tamanho_invalido, -20012);

    v_cpf        VARCHAR2(11);
    v_soma       PLS_INTEGER;
    v_resto      PLS_INTEGER;
    v_digito1    PLS_INTEGER;
    v_digito2    PLS_INTEGER;
    v_repetido   BOOLEAN := TRUE;
BEGIN
    IF p_cpf IS NULL THEN
        RAISE_APPLICATION_ERROR(-20011, 'FN_VALIDA_CPF: CPF nao informado');
    END IF;

    v_cpf := TRIM(p_cpf);

    IF LENGTH(v_cpf) <> 11 THEN
        RAISE_APPLICATION_ERROR(-20012, 'FN_VALIDA_CPF: CPF deve possuir 11 digitos, recebido ' || LENGTH(v_cpf));
    END IF;

    -- Forca a validacao de que todos os caracteres sao numericos.
    -- Um CPF alfanumerico dispara ORA-01722 (INVALID_NUMBER), tratado abaixo.
    IF TO_NUMBER(v_cpf) IS NULL THEN
        RETURN 'N';
    END IF;

    -- Regra de negocio: sequencias de digitos repetidos (111.111.111-11 etc.)
    -- passam no modulo 11 mas sao invalidas na pratica.
    FOR i IN 2 .. 11 LOOP
        IF SUBSTR(v_cpf, i, 1) <> SUBSTR(v_cpf, 1, 1) THEN
            v_repetido := FALSE;
            EXIT;
        END IF;
    END LOOP;

    IF v_repetido THEN
        RETURN 'N';
    END IF;

    -- 1o digito verificador: pesos de 10 a 2 sobre os 9 primeiros digitos
    v_soma := 0;
    FOR i IN 1 .. 9 LOOP
        v_soma := v_soma + TO_NUMBER(SUBSTR(v_cpf, i, 1)) * (11 - i);
    END LOOP;
    v_resto := MOD(v_soma, 11);
    v_digito1 := CASE WHEN v_resto < 2 THEN 0 ELSE 11 - v_resto END;

    -- 2o digito verificador: pesos de 11 a 2 sobre os 10 primeiros digitos
    -- (os 9 originais + o 1o digito verificador calculado acima)
    v_soma := 0;
    FOR i IN 1 .. 9 LOOP
        v_soma := v_soma + TO_NUMBER(SUBSTR(v_cpf, i, 1)) * (12 - i);
    END LOOP;
    v_soma := v_soma + v_digito1 * 2;
    v_resto := MOD(v_soma, 11);
    v_digito2 := CASE WHEN v_resto < 2 THEN 0 ELSE 11 - v_resto END;

    IF TO_NUMBER(SUBSTR(v_cpf, 10, 1)) = v_digito1
       AND TO_NUMBER(SUBSTR(v_cpf, 11, 1)) = v_digito2 THEN
        RETURN 'S';
    ELSE
        RETURN 'N';
    END IF;
EXCEPTION
    WHEN e_cpf_nulo THEN
        SP_REGISTRA_LOG('FN_VALIDA_CPF', SQLCODE, SQLERRM);
        RAISE;
    WHEN e_cpf_tamanho_invalido THEN
        SP_REGISTRA_LOG('FN_VALIDA_CPF', SQLCODE, SQLERRM);
        RAISE;
    WHEN INVALID_NUMBER THEN
        SP_REGISTRA_LOG('FN_VALIDA_CPF', SQLCODE, 'CPF contem caracteres nao numericos: ' || SQLERRM);
        RETURN 'N';
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('FN_VALIDA_CPF', SQLCODE, SQLERRM);
        RAISE;
END FN_VALIDA_CPF;
/
