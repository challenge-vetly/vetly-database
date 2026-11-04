-- ============================================================================
-- SPRINT 3 - MASTERING RELATIONAL AND NON-RELATIONAL DATABASE
-- TESTES DE EXECUCAO
--
-- Roteiro de execucao para tirar os prints exigidos pela documentacao (PDF):
-- caminho feliz + pelo menos uma excecao tratada para cada funcao/procedure/
-- trigger. Rode 01 a 05 antes deste arquivo.
-- ============================================================================
SET SERVEROUTPUT ON;

-- ============================================================
-- TESTE FUNCAO 1: FN_MONTA_JSON_ANIMAL
-- ============================================================

-- [CAMINHO FELIZ]
DECLARE
    v_json VARCHAR2(4000);
BEGIN
    v_json := FN_MONTA_JSON_ANIMAL('ANI-1', 'Rex', 'CAO', 'Labrador', 'M', 28.5, 'Joao Silva', '11999990001');
    DBMS_OUTPUT.PUT_LINE('[FN_MONTA_JSON_ANIMAL] CAMINHO FELIZ: ' || v_json);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[FN_MONTA_JSON_ANIMAL] CAMINHO FELIZ FALHOU: ' || SQLERRM);
END;
/

-- [EXCECAO] -20001 - campo obrigatorio (ID_ANIMAL) nulo
DECLARE
    v_json VARCHAR2(4000);
BEGIN
    v_json := FN_MONTA_JSON_ANIMAL(NULL, 'Sem ID', 'CAO', 'SRD', 'M', 10, 'Alguem', '11900000000');
    DBMS_OUTPUT.PUT_LINE('[FN_MONTA_JSON_ANIMAL] EXCECAO: NAO DISPAROU (ERRO NO TESTE)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[FN_MONTA_JSON_ANIMAL] EXCECAO CAMPO OBRIGATORIO: OK - ' || SQLERRM);
END;
/


-- ============================================================
-- TESTE FUNCAO 2: FN_VALIDA_CPF
-- ============================================================

-- [CAMINHO FELIZ] CPF valido (mesmo usado em PES-T1)
DECLARE
    v_valido CHAR(1);
BEGIN
    v_valido := FN_VALIDA_CPF('11144477735');
    DBMS_OUTPUT.PUT_LINE('[FN_VALIDA_CPF] CAMINHO FELIZ (CPF valido): ' || v_valido);
END;
/

-- [CAMINHO FELIZ] CPF com digitos verificadores errados -> 'N' (sem excecao)
DECLARE
    v_valido CHAR(1);
BEGIN
    v_valido := FN_VALIDA_CPF('12345678901');
    DBMS_OUTPUT.PUT_LINE('[FN_VALIDA_CPF] CPF com digito verificador invalido: ' || v_valido);
END;
/

-- [EXCECAO] -20011 - CPF nulo
DECLARE
    v_valido CHAR(1);
BEGIN
    v_valido := FN_VALIDA_CPF(NULL);
    DBMS_OUTPUT.PUT_LINE('[FN_VALIDA_CPF] EXCECAO: NAO DISPAROU (ERRO NO TESTE)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[FN_VALIDA_CPF] EXCECAO CPF NULO: OK - ' || SQLERRM);
END;
/

-- [EXCECAO] -20012 - CPF com tamanho invalido
DECLARE
    v_valido CHAR(1);
BEGIN
    v_valido := FN_VALIDA_CPF('123');
    DBMS_OUTPUT.PUT_LINE('[FN_VALIDA_CPF] EXCECAO: NAO DISPAROU (ERRO NO TESTE)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[FN_VALIDA_CPF] EXCECAO TAMANHO INVALIDO: OK - ' || SQLERRM);
END;
/

-- [EXCECAO] INVALID_NUMBER - CPF com caracteres nao numericos (retorna 'N', nao propaga)
DECLARE
    v_valido CHAR(1);
BEGIN
    v_valido := FN_VALIDA_CPF('ABCDEFGHIJK');
    DBMS_OUTPUT.PUT_LINE('[FN_VALIDA_CPF] EXCECAO INVALID_NUMBER TRATADA INTERNAMENTE: OK - resultado=' || v_valido);
END;
/


-- ============================================================
-- TESTE PROCEDIMENTO 1: PRC_LISTA_ANIMAIS_TUTORES_JSON
-- ============================================================

-- [CAMINHO FELIZ] lista todos os animais em JSON
BEGIN
    PRC_LISTA_ANIMAIS_TUTORES_JSON;
END;
/

-- [CAMINHO FELIZ] filtra por um tutor especifico
BEGIN
    PRC_LISTA_ANIMAIS_TUTORES_JSON(p_tb_tutor_id_tutor => 'TUT-1');
END;
/

-- [EXCECAO] -20002 - tutor inexistente
BEGIN
    PRC_LISTA_ANIMAIS_TUTORES_JSON(p_tb_tutor_id_tutor => 'TUT-INEXISTENTE');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[PRC_LISTA_ANIMAIS_TUTORES_JSON] EXCECAO TUTOR NAO ENCONTRADO: OK - ' || SQLERRM);
END;
/


-- ============================================================
-- TESTE PROCEDIMENTO 2: PRC_RELATORIO_CONSULTAS_VET_STATUS
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    PRC_RELATORIO_CONSULTAS_VET_STATUS;
END;
/

-- [EXCECAO] -20004 - tabela de fatos vazia
BEGIN
    DELETE FROM TB_CONSULTA;

    PRC_RELATORIO_CONSULTAS_VET_STATUS;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[PRC_RELATORIO_CONSULTAS_VET_STATUS] EXCECAO TABELA VAZIA: OK - ' || SQLERRM);
        ROLLBACK; -- desfaz o DELETE de teste, preservando a carga original
END;
/


-- ============================================================
-- TESTE TRIGGER: TRG_AUD_CONSULTA
-- (a carga de 02_carga_dados.sql ja gerou 6 linhas de INSERT auditadas)
-- ============================================================

-- [INSERT auditado]
BEGIN
    INSERT INTO TB_CONSULTA (ID_CONSULTA, DT_HR_CONSULTA, ST_CONSULTA, VL_CONSULTA, OBS_CONSULTA, TB_VETERINARIO_ID_VETERINARIO, TB_ANIMAL_ID_ANIMAL)
    VALUES ('CONS-7', SYSDATE, 'AGENDADA', 175.00, 'Consulta extra para teste de trigger', 'VET-1', 'ANI-1');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[TRG_AUD_CONSULTA] INSERT auditado: OK');
END;
/

-- [UPDATE auditado]
BEGIN
    UPDATE TB_CONSULTA SET ST_CONSULTA = 'REALIZADA', VL_CONSULTA = 190.00 WHERE ID_CONSULTA = 'CONS-7';
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[TRG_AUD_CONSULTA] UPDATE auditado: OK');
END;
/

-- [DELETE auditado]
BEGIN
    DELETE FROM TB_CONSULTA WHERE ID_CONSULTA = 'CONS-7';
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[TRG_AUD_CONSULTA] DELETE auditado: OK');
END;
/

-- Conferencia dos registros de auditoria gravados pela trigger
SELECT ID_AUDITORIA, NM_TABELA, NM_USUARIO, TP_OPERACAO, DT_HR_OPERACAO,
       DS_VALORES_ANTIGOS, DS_VALORES_NOVOS
FROM TB_AUDITORIA
WHERE DS_VALORES_ANTIGOS LIKE '%CONS-7%' OR DS_VALORES_NOVOS LIKE '%CONS-7%'
ORDER BY ID_AUDITORIA;

-- Conferencia final do log de excecoes tratadas por funcoes/procedures
SELECT ID_LOG, NM_PROCEDURE, NM_USUARIO, DT_OCORRENCIA, CD_ERRO, DS_MENSAGEM
FROM TB_LOG_ERRO
ORDER BY ID_LOG;
