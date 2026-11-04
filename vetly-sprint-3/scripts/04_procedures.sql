-- ============================================================================
-- SPRINT 3 - MASTERING RELATIONAL AND NON-RELATIONAL DATABASE
-- PROCEDIMENTOS
-- Depende de 03_funcoes.sql (SP_REGISTRA_LOG e FN_MONTA_JSON_ANIMAL).
-- ============================================================================

-- ============================================================================
-- PROCEDIMENTO 1: PRC_LISTA_ANIMAIS_TUTORES_JSON
--
-- Realiza JOIN entre TB_ANIMAL, TB_ESPECIE, TB_TUTOR e TB_PESSOA e exibe cada
-- linha como uma string JSON, montada manualmente pela FN_MONTA_JSON_ANIMAL
-- (Funcao 1) -- a conversao relacional -> JSON nunca usa funcao pronta do
-- Oracle. Aceita um filtro opcional por tutor.
-- ============================================================================
CREATE OR REPLACE PROCEDURE PRC_LISTA_ANIMAIS_TUTORES_JSON (
    p_tb_tutor_id_tutor IN TB_TUTOR.ID_TUTOR%TYPE DEFAULT NULL
) AS
    -- Excecoes de negocio proprias
    e_tutor_nao_encontrado EXCEPTION;
    e_nenhum_animal        EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_tutor_nao_encontrado, -20002);
    PRAGMA EXCEPTION_INIT(e_nenhum_animal, -20003);

    -- JOIN entre as 4 tabelas relacionais (Animal + Especie + Tutor + Pessoa)
    CURSOR c_animais IS
        SELECT
            a.ID_ANIMAL, a.NM_ANIMAL, a.RC_ANIMAL, a.SX_ANIMAL, a.NR_PESO_ANIMAL,
            e.NM_ESPECIE,
            p.NM_PESSOA AS nm_tutor, p.TEL_PESSOA AS tel_tutor
        FROM TB_ANIMAL a
            JOIN TB_ESPECIE e ON e.ID_ESPECIE = a.TB_ESPECIE_ID_ESPECIE
            JOIN TB_TUTOR   t ON t.ID_TUTOR   = a.TB_TUTOR_ID_TUTOR
            JOIN TB_PESSOA  p ON p.ID_PESSOA  = t.TB_PESSOA_ID_PESSOA
        WHERE p_tb_tutor_id_tutor IS NULL OR t.ID_TUTOR = p_tb_tutor_id_tutor
        ORDER BY a.NM_ANIMAL;

    v_qt_encontrados  PLS_INTEGER := 0;
    v_qt_tutor_check  PLS_INTEGER;
    v_json            VARCHAR2(4000);
BEGIN
    -- Validacao: se um tutor foi informado como filtro, ele precisa existir
    IF p_tb_tutor_id_tutor IS NOT NULL THEN
        SELECT COUNT(*) INTO v_qt_tutor_check FROM TB_TUTOR WHERE ID_TUTOR = p_tb_tutor_id_tutor;
        IF v_qt_tutor_check = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'PRC_LISTA_ANIMAIS_TUTORES_JSON: tutor ' || p_tb_tutor_id_tutor || ' nao encontrado');
        END IF;
    END IF;

    DBMS_OUTPUT.PUT_LINE('=======================================================================');
    DBMS_OUTPUT.PUT_LINE(' PROCEDIMENTO 1 - ANIMAIS + TUTORES EM JSON (JOIN manual -> JSON manual)');
    DBMS_OUTPUT.PUT_LINE('=======================================================================');

    FOR r_animal IN c_animais LOOP
        v_json := FN_MONTA_JSON_ANIMAL(
            p_id_animal   => r_animal.ID_ANIMAL,
            p_nm_animal   => r_animal.NM_ANIMAL,
            p_nm_especie  => r_animal.NM_ESPECIE,
            p_rc_animal   => r_animal.RC_ANIMAL,
            p_sx_animal   => r_animal.SX_ANIMAL,
            p_peso_animal => r_animal.NR_PESO_ANIMAL,
            p_nm_tutor    => r_animal.nm_tutor,
            p_tel_tutor   => r_animal.tel_tutor
        );

        DBMS_OUTPUT.PUT_LINE(v_json);
        v_qt_encontrados := v_qt_encontrados + 1;
    END LOOP;

    IF v_qt_encontrados = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'PRC_LISTA_ANIMAIS_TUTORES_JSON: nenhum animal encontrado para o filtro informado');
    END IF;

    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(' Total de registros exibidos em JSON: ' || v_qt_encontrados);
    DBMS_OUTPUT.PUT_LINE('=======================================================================');
EXCEPTION
    WHEN e_tutor_nao_encontrado THEN
        SP_REGISTRA_LOG('PRC_LISTA_ANIMAIS_TUTORES_JSON', SQLCODE, SQLERRM);
        RAISE;
    WHEN e_nenhum_animal THEN
        SP_REGISTRA_LOG('PRC_LISTA_ANIMAIS_TUTORES_JSON', SQLCODE, SQLERRM);
        RAISE;
    WHEN VALUE_ERROR THEN
        SP_REGISTRA_LOG('PRC_LISTA_ANIMAIS_TUTORES_JSON', SQLCODE, 'Erro de valor/tipo: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('PRC_LISTA_ANIMAIS_TUTORES_JSON', SQLCODE, SQLERRM);
        RAISE;
END PRC_LISTA_ANIMAIS_TUTORES_JSON;
/

-- ============================================================================
-- PROCEDIMENTO 2: PRC_RELATORIO_CONSULTAS_VET_STATUS
--
-- Tabela de fatos: TB_CONSULTA. Categorias: veterinario (1a categoria) e
-- status da consulta (2a categoria). Numerico somado: VL_CONSULTA.
--
-- Toda soma (por combinacao completa, subtotal por veterinario e total geral)
-- e feita manualmente dentro do bloco PL/SQL, atraves de variaveis
-- acumuladoras e um "controle de quebra" (control break) sobre um cursor
-- ordenado -- SEM usar SUM()/GROUP BY/ROLLUP/CUBE/GROUPING SETS/GROUPING.
-- ============================================================================
CREATE OR REPLACE PROCEDURE PRC_RELATORIO_CONSULTAS_VET_STATUS AS
    e_fatos_vazios EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_fatos_vazios, -20004);

    -- Cursor de fatos DETALHADOS (sem agregacao), ordenado pela hierarquia
    -- de exibicao: veterinario (categoria 1) -> status (categoria 2)
    CURSOR c_fatos IS
        SELECT
            v.ID_VETERINARIO,
            p.NM_PESSOA   AS nm_veterinario,
            c.ST_CONSULTA,
            c.VL_CONSULTA
        FROM TB_CONSULTA c
            JOIN TB_VETERINARIO v ON v.ID_VETERINARIO = c.TB_VETERINARIO_ID_VETERINARIO
            JOIN TB_PESSOA      p ON p.ID_PESSOA       = v.TB_PESSOA_ID_PESSOA
        ORDER BY v.ID_VETERINARIO, c.ST_CONSULTA;

    v_vet_atual        TB_VETERINARIO.ID_VETERINARIO%TYPE := NULL;
    v_nm_vet_atual     VARCHAR2(100) := NULL;
    v_status_atual     TB_CONSULTA.ST_CONSULTA%TYPE       := NULL;

    v_soma_combinacao  NUMBER := 0; -- soma da combinacao (veterinario, status) corrente
    v_subtotal_vet     NUMBER := 0; -- soma acumulada do veterinario corrente
    v_total_geral      NUMBER := 0; -- soma acumulada de todas as consultas

    v_qt_linhas        PLS_INTEGER := 0;
    v_primeira_linha   BOOLEAN := TRUE;

    PROCEDURE imprime_linha(p_vet IN VARCHAR2, p_status IN VARCHAR2, p_valor IN NUMBER) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            RPAD(NVL(p_vet, '-'),    24) ||
            RPAD(NVL(p_status, '-'),16) ||
            TO_CHAR(p_valor, 'FM9999990.00')
        );
    END imprime_linha;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=======================================================================');
    DBMS_OUTPUT.PUT_LINE(' PROCEDIMENTO 2 - CONSULTAS POR VETERINARIO x STATUS (somas manuais)');
    DBMS_OUTPUT.PUT_LINE('=======================================================================');
    DBMS_OUTPUT.PUT_LINE(RPAD('VETERINARIO', 24) || RPAD('STATUS', 16) || 'VALOR (R$)');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));

    FOR r IN c_fatos LOOP
        v_qt_linhas := v_qt_linhas + 1;

        IF r.VL_CONSULTA IS NULL THEN
            RAISE VALUE_ERROR;
        END IF;

        IF v_primeira_linha THEN
            v_vet_atual    := r.ID_VETERINARIO;
            v_nm_vet_atual := r.nm_veterinario;
            v_status_atual := r.ST_CONSULTA;
            v_primeira_linha := FALSE;
        END IF;

        -- Quebra de STATUS (2a categoria): fecha a combinacao corrente
        IF r.ST_CONSULTA <> v_status_atual OR r.ID_VETERINARIO <> v_vet_atual THEN
            imprime_linha(v_nm_vet_atual, v_status_atual, v_soma_combinacao);
            v_subtotal_vet    := v_subtotal_vet + v_soma_combinacao;
            v_soma_combinacao := 0;
            v_status_atual    := r.ST_CONSULTA;
        END IF;

        -- Quebra de VETERINARIO (1a categoria): fecha o subtotal do veterinario anterior
        IF r.ID_VETERINARIO <> v_vet_atual THEN
            imprime_linha(NULL, NULL, v_subtotal_vet); -- ambas categorias nulas = linha de subtotal
            DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));
            v_total_geral  := v_total_geral + v_subtotal_vet;
            v_subtotal_vet := 0;
            v_vet_atual    := r.ID_VETERINARIO;
            v_nm_vet_atual := r.nm_veterinario;
        END IF;

        v_soma_combinacao := v_soma_combinacao + r.VL_CONSULTA;
    END LOOP;

    IF v_qt_linhas = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'PRC_RELATORIO_CONSULTAS_VET_STATUS: TB_CONSULTA nao possui linhas de fato');
    END IF;

    -- Fecha a ultima combinacao e o ultimo subtotal pendentes apos o loop
    imprime_linha(v_nm_vet_atual, v_status_atual, v_soma_combinacao);
    v_subtotal_vet := v_subtotal_vet + v_soma_combinacao;

    imprime_linha(NULL, NULL, v_subtotal_vet);
    v_total_geral := v_total_geral + v_subtotal_vet;

    DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));
    -- Total geral: as duas categorias ausentes (nulas), como exigido
    imprime_linha(NULL, NULL, v_total_geral);
    DBMS_OUTPUT.PUT_LINE(' (linha com veterinario e status nulos = TOTAL GERAL)');
    DBMS_OUTPUT.PUT_LINE('=======================================================================');
EXCEPTION
    WHEN e_fatos_vazios THEN
        SP_REGISTRA_LOG('PRC_RELATORIO_CONSULTAS_VET_STATUS', SQLCODE, SQLERRM);
        RAISE;
    WHEN VALUE_ERROR THEN
        SP_REGISTRA_LOG('PRC_RELATORIO_CONSULTAS_VET_STATUS', SQLCODE, 'VL_CONSULTA nulo/invalido em uma linha de fato');
        RAISE;
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('PRC_RELATORIO_CONSULTAS_VET_STATUS', SQLCODE, SQLERRM);
        RAISE;
END PRC_RELATORIO_CONSULTAS_VET_STATUS;
/
