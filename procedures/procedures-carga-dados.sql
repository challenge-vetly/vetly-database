-- ============================================================
-- PROCEDURES DE CARGA DE DADOS - SISTEMA VETERINÁRIO
-- Gerado em: 2026-05-13
-- Oracle Database 11g
-- ============================================================
-- Exceções utilizadas em todas as procedures:
--   1. DUP_VAL_ON_INDEX  - Violação de chave única/primária
--   2. VALUE_ERROR       - Tipo/tamanho de dado inválido
--   3. WHEN OTHERS       - Qualquer outra exceção não prevista
-- ============================================================


-- ============================================================
-- PROCEDURE: SP_INSERIR_USUARIO
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INSERIR_USUARIO (
    p_id_usuario       IN TB_USUARIO.ID_USUARIO%TYPE,
    p_em_usuario       IN TB_USUARIO.EM_USUARIO%TYPE,
    p_rl_usuario       IN TB_USUARIO.RL_USUARIO%TYPE,
    p_fl_atv_usuario   IN TB_USUARIO.FL_ATV_USUARIO%TYPE,
    p_sen_hash_usuario IN TB_USUARIO.SEN_HASH_USUARIO%TYPE
)
AS
BEGIN
    INSERT INTO TB_USUARIO (
        ID_USUARIO,
        EM_USUARIO,
        RL_USUARIO,
        FL_ATV_USUARIO,
        SEN_HASH_USUARIO
    ) VALUES (
        p_id_usuario,
        p_em_usuario,
        p_rl_usuario,
        p_fl_atv_usuario,
        p_sen_hash_usuario
    );

    COMMIT;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_USUARIO', USER, SYSDATE, SQLCODE, 'CHAVE DUPLICADA: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN VALUE_ERROR THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_USUARIO', USER, SYSDATE, SQLCODE, 'ERRO DE VALOR/TIPO: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_USUARIO', USER, SYSDATE, SQLCODE, 'ERRO INESPERADO: ' || SQLERRM);
        COMMIT;
        RAISE;
END SP_INSERIR_USUARIO;
/


-- ============================================================
-- PROCEDURE: SP_INSERIR_TUTOR
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INSERIR_TUTOR (
    p_id_tutor              IN TB_TUTOR.ID_TUTOR%TYPE,
    p_nm_tutor              IN TB_TUTOR.NM_TUTOR%TYPE,
    p_cpf_tutor             IN TB_TUTOR.CPF_TUTOR%TYPE,
    p_tel_tutor             IN TB_TUTOR.TEL_TUTOR%TYPE,
    p_tb_usuario_id_usuario IN TB_TUTOR.TB_USUARIO_ID_USUARIO%TYPE
)
AS
BEGIN
    INSERT INTO TB_TUTOR (
        ID_TUTOR,
        NM_TUTOR,
        CPF_TUTOR,
        TEL_TUTOR,
        TB_USUARIO_ID_USUARIO
    ) VALUES (
        p_id_tutor,
        p_nm_tutor,
        p_cpf_tutor,
        p_tel_tutor,
        p_tb_usuario_id_usuario
    );

    COMMIT;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_TUTOR', USER, SYSDATE, SQLCODE, 'CHAVE DUPLICADA: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN VALUE_ERROR THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_TUTOR', USER, SYSDATE, SQLCODE, 'ERRO DE VALOR/TIPO: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_TUTOR', USER, SYSDATE, SQLCODE, 'ERRO INESPERADO: ' || SQLERRM);
        COMMIT;
        RAISE;
END SP_INSERIR_TUTOR;
/


-- ============================================================
-- PROCEDURE: SP_INSERIR_VETERINARIO
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INSERIR_VETERINARIO (
    p_id_veterinario        IN TB_VETERINARIO.ID_VETERINARIO%TYPE,
    p_nm_veterinario        IN TB_VETERINARIO.NM_VETERINARIO%TYPE,
    p_cpf_veterinario       IN TB_VETERINARIO.CPF_VETERINARIO%TYPE,
    p_crmv_veterinario      IN TB_VETERINARIO.CRMV_VETERINARIO%TYPE,
    p_tel_veterinario       IN TB_VETERINARIO.TEL_VETERINARIO%TYPE,
    p_uf_atd_veterinario    IN TB_VETERINARIO.UF_ATD_VETERINARIO%TYPE,
    p_tb_usuario_id_usuario IN TB_VETERINARIO.TB_USUARIO_ID_USUARIO%TYPE
)
AS
BEGIN
    INSERT INTO TB_VETERINARIO (
        ID_VETERINARIO,
        NM_VETERINARIO,
        CPF_VETERINARIO,
        CRMV_VETERINARIO,
        TEL_VETERINARIO,
        UF_ATD_VETERINARIO,
        TB_USUARIO_ID_USUARIO
    ) VALUES (
        p_id_veterinario,
        p_nm_veterinario,
        p_cpf_veterinario,
        p_crmv_veterinario,
        p_tel_veterinario,
        p_uf_atd_veterinario,
        p_tb_usuario_id_usuario
    );

    COMMIT;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_VETERINARIO', USER, SYSDATE, SQLCODE, 'CHAVE DUPLICADA: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN VALUE_ERROR THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_VETERINARIO', USER, SYSDATE, SQLCODE, 'ERRO DE VALOR/TIPO: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_VETERINARIO', USER, SYSDATE, SQLCODE, 'ERRO INESPERADO: ' || SQLERRM);
        COMMIT;
        RAISE;
END SP_INSERIR_VETERINARIO;
/


-- ============================================================
-- PROCEDURE: SP_INSERIR_ESPECIALIDADE_VET
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INSERIR_ESPECIALIDADE_VET (
    p_id_especialidade_vet IN TB_ESPECIALIDADES_VET.ID_ESPECIALIDADE_VET%TYPE,
    p_nm_especialidade     IN TB_ESPECIALIDADES_VET.NM_ESPECIALIDADE%TYPE,
    p_ds_especialidade     IN TB_ESPECIALIDADES_VET.DS_ESPECIALIDADE%TYPE
)
AS
BEGIN
    INSERT INTO TB_ESPECIALIDADES_VET (
        ID_ESPECIALIDADE_VET,
        NM_ESPECIALIDADE,
        DS_ESPECIALIDADE
    ) VALUES (
        p_id_especialidade_vet,
        p_nm_especialidade,
        p_ds_especialidade
    );

    COMMIT;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_ESPECIALIDADE_VET', USER, SYSDATE, SQLCODE, 'CHAVE DUPLICADA: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN VALUE_ERROR THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_ESPECIALIDADE_VET', USER, SYSDATE, SQLCODE, 'ERRO DE VALOR/TIPO: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_ESPECIALIDADE_VET', USER, SYSDATE, SQLCODE, 'ERRO INESPERADO: ' || SQLERRM);
        COMMIT;
        RAISE;
END SP_INSERIR_ESPECIALIDADE_VET;
/


-- ============================================================
-- PROCEDURE: SP_INSERIR_VET_ESPECIALIDADE
-- (Tabela associativa N:N entre Veterinário e Especialidade)
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INSERIR_VET_ESPECIALIDADE (
    p_tb_vet_id_veterinario          IN TB_VETERINARIO_ESPECIALIDADE.TB_VET_ID_VETERINARIO%TYPE,
    p_tb_especi_id_especialidade_vet IN TB_VETERINARIO_ESPECIALIDADE.TB_ESPECI_ID_ESPECIALIDADE_VET%TYPE
)
AS
BEGIN
    INSERT INTO TB_VETERINARIO_ESPECIALIDADE (
        TB_VET_ID_VETERINARIO,
        TB_ESPECI_ID_ESPECIALIDADE_VET
    ) VALUES (
        p_tb_vet_id_veterinario,
        p_tb_especi_id_especialidade_vet
    );

    COMMIT;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_VET_ESPECIALIDADE', USER, SYSDATE, SQLCODE, 'CHAVE DUPLICADA: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN VALUE_ERROR THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_VET_ESPECIALIDADE', USER, SYSDATE, SQLCODE, 'ERRO DE VALOR/TIPO: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_VET_ESPECIALIDADE', USER, SYSDATE, SQLCODE, 'ERRO INESPERADO: ' || SQLERRM);
        COMMIT;
        RAISE;
END SP_INSERIR_VET_ESPECIALIDADE;
/


-- ============================================================
-- PROCEDURE: SP_INSERIR_ESPECIE
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INSERIR_ESPECIE (
    p_id_especie                    IN TB_ESPECIE.ID_ESPECIE%TYPE,
    p_nm_especie                    IN TB_ESPECIE.NM_ESPECIE%TYPE,
    p_tb_veterinario_id_veterinario IN TB_ESPECIE.TB_VETERINARIO_ID_VETERINARIO%TYPE
)
AS
BEGIN
    INSERT INTO TB_ESPECIE (
        ID_ESPECIE,
        NM_ESPECIE,
        TB_VETERINARIO_ID_VETERINARIO
    ) VALUES (
        p_id_especie,
        p_nm_especie,
        p_tb_veterinario_id_veterinario
    );

    COMMIT;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_ESPECIE', USER, SYSDATE, SQLCODE, 'CHAVE DUPLICADA: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN VALUE_ERROR THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_ESPECIE', USER, SYSDATE, SQLCODE, 'ERRO DE VALOR/TIPO: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_ESPECIE', USER, SYSDATE, SQLCODE, 'ERRO INESPERADO: ' || SQLERRM);
        COMMIT;
        RAISE;
END SP_INSERIR_ESPECIE;
/


-- ============================================================
-- PROCEDURE: SP_INSERIR_ANIMAL
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INSERIR_ANIMAL (
    p_id_animal             IN TB_ANIMAL.ID_ANIMAL%TYPE,
    p_nm_animal             IN TB_ANIMAL.NM_ANIMAL%TYPE,
    p_rc_animal             IN TB_ANIMAL.RC_ANIMAL%TYPE,
    p_sx_animal             IN TB_ANIMAL.SX_ANIMAL%TYPE,
    p_dt_nasc_animal        IN TB_ANIMAL.DT_NASC_ANIMAL%TYPE,
    p_nr_peso_animal        IN TB_ANIMAL.NR_PESO_ANIMAL%TYPE,
    p_tb_tutor_id_tutor     IN TB_ANIMAL.TB_TUTOR_ID_TUTOR%TYPE,
    p_tb_especie_id_especie IN TB_ANIMAL.TB_ESPECIE_ID_ESPECIE%TYPE
)
AS
BEGIN
    INSERT INTO TB_ANIMAL (
        ID_ANIMAL,
        NM_ANIMAL,
        RC_ANIMAL,
        SX_ANIMAL,
        DT_NASC_ANIMAL,
        NR_PESO_ANIMAL,
        TB_TUTOR_ID_TUTOR,
        TB_ESPECIE_ID_ESPECIE
    ) VALUES (
        p_id_animal,
        p_nm_animal,
        p_rc_animal,
        p_sx_animal,
        p_dt_nasc_animal,
        p_nr_peso_animal,
        p_tb_tutor_id_tutor,
        p_tb_especie_id_especie
    );

    COMMIT;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_ANIMAL', USER, SYSDATE, SQLCODE, 'CHAVE DUPLICADA: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN VALUE_ERROR THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_ANIMAL', USER, SYSDATE, SQLCODE, 'ERRO DE VALOR/TIPO: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_ANIMAL', USER, SYSDATE, SQLCODE, 'ERRO INESPERADO: ' || SQLERRM);
        COMMIT;
        RAISE;
END SP_INSERIR_ANIMAL;
/


-- ============================================================
-- PROCEDURE: SP_INSERIR_CONSULTA
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INSERIR_CONSULTA (
    p_id_consulta                   IN TB_CONSULTA.ID_CONSULTA%TYPE,
    p_dt_hr_consulta                IN TB_CONSULTA.DT_HR_CONSULTA%TYPE,
    p_st_consulta                   IN TB_CONSULTA.ST_CONSULTA%TYPE,
    p_vl_consulta                   IN TB_CONSULTA.VL_CONSULTA%TYPE,
    p_obs_consulta                  IN TB_CONSULTA.OBS_CONSULTA%TYPE,
    p_tb_veterinario_id_veterinario IN TB_CONSULTA.TB_VETERINARIO_ID_VETERINARIO%TYPE,
    p_tb_animal_id_animal           IN TB_CONSULTA.TB_ANIMAL_ID_ANIMAL%TYPE
)
AS
BEGIN
    INSERT INTO TB_CONSULTA (
        ID_CONSULTA,
        DT_HR_CONSULTA,
        ST_CONSULTA,
        VL_CONSULTA,
        OBS_CONSULTA,
        TB_VETERINARIO_ID_VETERINARIO,
        TB_ANIMAL_ID_ANIMAL
    ) VALUES (
        p_id_consulta,
        p_dt_hr_consulta,
        p_st_consulta,
        p_vl_consulta,
        p_obs_consulta,
        p_tb_veterinario_id_veterinario,
        p_tb_animal_id_animal
    );

    COMMIT;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_CONSULTA', USER, SYSDATE, SQLCODE, 'CHAVE DUPLICADA: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN VALUE_ERROR THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_CONSULTA', USER, SYSDATE, SQLCODE, 'ERRO DE VALOR/TIPO: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_CONSULTA', USER, SYSDATE, SQLCODE, 'ERRO INESPERADO: ' || SQLERRM);
        COMMIT;
        RAISE;
END SP_INSERIR_CONSULTA;
/


-- ============================================================
-- PROCEDURE: SP_INSERIR_PRONTUARIO
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INSERIR_PRONTUARIO (
    p_id_prontuario       IN TB_PRONTUARIO.ID_PRONTUARIO%TYPE,
    p_dt_upd_pronturario  IN TB_PRONTUARIO.DT_UPD_PRONTURARIO%TYPE,
    p_tb_animal_id_animal IN TB_PRONTUARIO.TB_ANIMAL_ID_ANIMAL%TYPE
)
AS
BEGIN
    INSERT INTO TB_PRONTUARIO (
        ID_PRONTUARIO,
        DT_UPD_PRONTURARIO,
        TB_ANIMAL_ID_ANIMAL
    ) VALUES (
        p_id_prontuario,
        p_dt_upd_pronturario,
        p_tb_animal_id_animal
    );

    COMMIT;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_PRONTUARIO', USER, SYSDATE, SQLCODE, 'CHAVE DUPLICADA: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN VALUE_ERROR THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_PRONTUARIO', USER, SYSDATE, SQLCODE, 'ERRO DE VALOR/TIPO: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_PRONTUARIO', USER, SYSDATE, SQLCODE, 'ERRO INESPERADO: ' || SQLERRM);
        COMMIT;
        RAISE;
END SP_INSERIR_PRONTUARIO;
/


-- ============================================================
-- PROCEDURE: SP_INSERIR_EVOLUCAO_CLINICA
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INSERIR_EVOLUCAO_CLINICA (
    p_id_evolucao_clinica         IN TB_EVOLUCAO_CLINICA.ID_EVOLUCAO_CLINICA%TYPE,
    p_ant_evolucao_clinica        IN TB_EVOLUCAO_CLINICA.ANT_EVOLUCAO_CLINICA%TYPE,
    p_tb_consulta_id_consulta     IN TB_EVOLUCAO_CLINICA.TB_CONSULTA_ID_CONSULTA%TYPE,
    p_tb_prontuario_id_prontuario IN TB_EVOLUCAO_CLINICA.TB_PRONTUARIO_ID_PRONTUARIO%TYPE
)
AS
BEGIN
    INSERT INTO TB_EVOLUCAO_CLINICA (
        ID_EVOLUCAO_CLINICA,
        ANT_EVOLUCAO_CLINICA,
        TB_CONSULTA_ID_CONSULTA,
        TB_PRONTUARIO_ID_PRONTUARIO
    ) VALUES (
        p_id_evolucao_clinica,
        p_ant_evolucao_clinica,
        p_tb_consulta_id_consulta,
        p_tb_prontuario_id_prontuario
    );

    COMMIT;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_EVOLUCAO_CLINICA', USER, SYSDATE, SQLCODE, 'CHAVE DUPLICADA: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN VALUE_ERROR THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_EVOLUCAO_CLINICA', USER, SYSDATE, SQLCODE, 'ERRO DE VALOR/TIPO: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_EVOLUCAO_CLINICA', USER, SYSDATE, SQLCODE, 'ERRO INESPERADO: ' || SQLERRM);
        COMMIT;
        RAISE;
END SP_INSERIR_EVOLUCAO_CLINICA;
/


-- ============================================================
-- PROCEDURE: SP_INSERIR_EXAME
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INSERIR_EXAME (
    p_id_exame                    IN TB_EXAME.ID_EXAME%TYPE,
    p_nm_exame                    IN TB_EXAME.NM_EXAME%TYPE,
    p_ds_res_exame                IN TB_EXAME.DS_RES_EXAME%TYPE,
    p_dt_res_exame                IN TB_EXAME.DT_RES_EXAME%TYPE,
    p_st_exame                    IN TB_EXAME.ST_EXAME%TYPE,
    p_tb_consulta_id_consulta     IN TB_EXAME.TB_CONSULTA_ID_CONSULTA%TYPE,
    p_tb_prontuario_id_prontuario IN TB_EXAME.TB_PRONTUARIO_ID_PRONTUARIO%TYPE,
    p_tb_animal_id_animal         IN TB_EXAME.TB_ANIMAL_ID_ANIMAL%TYPE
)
AS
BEGIN
    INSERT INTO TB_EXAME (
        ID_EXAME,
        NM_EXAME,
        DS_RES_EXAME,
        DT_RES_EXAME,
        ST_EXAME,
        TB_CONSULTA_ID_CONSULTA,
        TB_PRONTUARIO_ID_PRONTUARIO,
        TB_ANIMAL_ID_ANIMAL
    ) VALUES (
        p_id_exame,
        p_nm_exame,
        p_ds_res_exame,
        p_dt_res_exame,
        p_st_exame,
        p_tb_consulta_id_consulta,
        p_tb_prontuario_id_prontuario,
        p_tb_animal_id_animal
    );

    COMMIT;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_EXAME', USER, SYSDATE, SQLCODE, 'CHAVE DUPLICADA: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN VALUE_ERROR THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_EXAME', USER, SYSDATE, SQLCODE, 'ERRO DE VALOR/TIPO: ' || SQLERRM);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('SP_INSERIR_EXAME', USER, SYSDATE, SQLCODE, 'ERRO INESPERADO: ' || SQLERRM);
        COMMIT;
        RAISE;
END SP_INSERIR_EXAME;
/


-- ============================================================
-- FIM DO SCRIPT - RESUMO DAS PROCEDURES CRIADAS
-- ============================================================
-- 1.  SP_INSERIR_USUARIO            -> TB_USUARIO
-- 2.  SP_INSERIR_TUTOR              -> TB_TUTOR
-- 3.  SP_INSERIR_VETERINARIO        -> TB_VETERINARIO
-- 4.  SP_INSERIR_ESPECIALIDADE_VET  -> TB_ESPECIALIDADES_VET
-- 5.  SP_INSERIR_VET_ESPECIALIDADE  -> TB_VETERINARIO_ESPECIALIDADE
-- 6.  SP_INSERIR_ESPECIE            -> TB_ESPECIE
-- 7.  SP_INSERIR_ANIMAL             -> TB_ANIMAL
-- 8.  SP_INSERIR_CONSULTA           -> TB_CONSULTA
-- 9.  SP_INSERIR_PRONTUARIO         -> TB_PRONTUARIO
-- 10. SP_INSERIR_EVOLUCAO_CLINICA   -> TB_EVOLUCAO_CLINICA
-- 11. SP_INSERIR_EXAME              -> TB_EXAME
-- ============================================================
-- EXCEÇÕES TRATADAS EM CADA PROCEDURE:
--   DUP_VAL_ON_INDEX  -> Inserção de ID ou índice único já existente
--   VALUE_ERROR       -> Dado incompatível com tipo/tamanho da coluna
--   WHEN OTHERS       -> Qualquer outra exceção (FK violada, etc.)
-- ============================================================