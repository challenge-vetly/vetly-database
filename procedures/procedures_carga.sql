
-- ============================================================
-- PROCEDURE AUXILIAR: REGISTRA LOG DE ERRO
-- ============================================================
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
        SQ_LOG_ERRO.NEXTVAL,
        p_nm_procedure,
        USER,
        SYSDATE,
        p_cd_erro,
        p_ds_mensagem
    );
    COMMIT;
END SP_REGISTRA_LOG;
/

-- ============================================================
-- 1. TB_USUARIO
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INS_USUARIO (
    p_id_usuario        IN TB_USUARIO.ID_USUARIO%TYPE,
    p_em_usuario        IN TB_USUARIO.EM_USUARIO%TYPE,
    p_rl_usuario        IN TB_USUARIO.RL_USUARIO%TYPE,
    p_fl_atv_usuario    IN TB_USUARIO.FL_ATV_USUARIO%TYPE,
    p_sen_hash_usuario  IN TB_USUARIO.SEN_HASH_USUARIO%TYPE
) AS
BEGIN
    INSERT INTO TB_USUARIO (
        ID_USUARIO, EM_USUARIO, RL_USUARIO, FL_ATV_USUARIO, SEN_HASH_USUARIO
    ) VALUES (
        p_id_usuario, p_em_usuario, p_rl_usuario, p_fl_atv_usuario, p_sen_hash_usuario
    );
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        SP_REGISTRA_LOG('SP_INS_USUARIO', SQLCODE, 'Registro duplicado: ' || SQLERRM);
        RAISE;
    WHEN VALUE_ERROR THEN
        SP_REGISTRA_LOG('SP_INS_USUARIO', SQLCODE, 'Erro de valor/tipo: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('SP_INS_USUARIO', SQLCODE, SQLERRM);
        RAISE;
END SP_INS_USUARIO;
/

-- ============================================================
-- 2. TB_PESSOA
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INS_PESSOA (
    p_id_pessoa     IN TB_PESSOA.ID_PESSOA%TYPE,
    p_nm_pessoa     IN TB_PESSOA.NM_PESSOA%TYPE,
    p_cpf_pessoa    IN TB_PESSOA.CPF_PESSOA%TYPE,
    p_tel_pessoa    IN TB_PESSOA.TEL_PESSOA%TYPE
) AS
BEGIN
    INSERT INTO TB_PESSOA (
        ID_PESSOA, NM_PESSOA, CPF_PESSOA, TEL_PESSOA
    ) VALUES (
        p_id_pessoa, p_nm_pessoa, p_cpf_pessoa, p_tel_pessoa
    );
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        SP_REGISTRA_LOG('SP_INS_PESSOA', SQLCODE, 'Registro duplicado: ' || SQLERRM);
        RAISE;
    WHEN VALUE_ERROR THEN
        SP_REGISTRA_LOG('SP_INS_PESSOA', SQLCODE, 'Erro de valor/tipo: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('SP_INS_PESSOA', SQLCODE, SQLERRM);
        RAISE;
END SP_INS_PESSOA;
/

-- ============================================================
-- 3. TB_ESPECIE
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INS_ESPECIE (
    p_id_especie    IN TB_ESPECIE.ID_ESPECIE%TYPE,
    p_nm_especie    IN TB_ESPECIE.NM_ESPECIE%TYPE
) AS
BEGIN
    INSERT INTO TB_ESPECIE (
        ID_ESPECIE, NM_ESPECIE
    ) VALUES (
        p_id_especie, p_nm_especie
    );
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        SP_REGISTRA_LOG('SP_INS_ESPECIE', SQLCODE, 'Registro duplicado: ' || SQLERRM);
        RAISE;
    WHEN VALUE_ERROR THEN
        SP_REGISTRA_LOG('SP_INS_ESPECIE', SQLCODE, 'Erro de valor/tipo: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('SP_INS_ESPECIE', SQLCODE, SQLERRM);
        RAISE;
END SP_INS_ESPECIE;
/

-- ============================================================
-- 4. TB_ESPECIALIDADES_VET
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INS_ESPECIALIDADE_VET (
    p_id_especialidade_vet  IN TB_ESPECIALIDADES_VET.ID_ESPECIALIDADE_VET%TYPE,
    p_nm_especialidade      IN TB_ESPECIALIDADES_VET.NM_ESPECIALIDADE%TYPE,
    p_ds_especialidade      IN TB_ESPECIALIDADES_VET.DS_ESPECIALIDADE%TYPE
) AS
BEGIN
    INSERT INTO TB_ESPECIALIDADES_VET (
        ID_ESPECIALIDADE_VET, NM_ESPECIALIDADE, DS_ESPECIALIDADE
    ) VALUES (
        p_id_especialidade_vet, p_nm_especialidade, p_ds_especialidade
    );
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        SP_REGISTRA_LOG('SP_INS_ESPECIALIDADE_VET', SQLCODE, 'Registro duplicado: ' || SQLERRM);
        RAISE;
    WHEN VALUE_ERROR THEN
        SP_REGISTRA_LOG('SP_INS_ESPECIALIDADE_VET', SQLCODE, 'Erro de valor/tipo: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('SP_INS_ESPECIALIDADE_VET', SQLCODE, SQLERRM);
        RAISE;
END SP_INS_ESPECIALIDADE_VET;
/

-- ============================================================
-- 5. TB_TUTOR
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INS_TUTOR (
    p_id_tutor              IN TB_TUTOR.ID_TUTOR%TYPE,
    p_tb_usuario_id_usuario IN TB_TUTOR.TB_USUARIO_ID_USUARIO%TYPE,
    p_tb_pessoa_id_pessoa   IN TB_TUTOR.TB_PESSOA_ID_PESSOA%TYPE
) AS
BEGIN
    INSERT INTO TB_TUTOR (
        ID_TUTOR, TB_USUARIO_ID_USUARIO, TB_PESSOA_ID_PESSOA
    ) VALUES (
        p_id_tutor, p_tb_usuario_id_usuario, p_tb_pessoa_id_pessoa
    );
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        SP_REGISTRA_LOG('SP_INS_TUTOR', SQLCODE, 'Registro duplicado: ' || SQLERRM);
        RAISE;
    WHEN NO_DATA_FOUND THEN
        SP_REGISTRA_LOG('SP_INS_TUTOR', SQLCODE, 'FK nao encontrada: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('SP_INS_TUTOR', SQLCODE, SQLERRM);
        RAISE;
END SP_INS_TUTOR;
/

-- ============================================================
-- 6. TB_VETERINARIO
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INS_VETERINARIO (
    p_id_veterinario        IN TB_VETERINARIO.ID_VETERINARIO%TYPE,
    p_crmv_veterinario      IN TB_VETERINARIO.CRMV_VETERINARIO%TYPE,
    p_tb_usuario_id_usuario IN TB_VETERINARIO.TB_USUARIO_ID_USUARIO%TYPE,
    p_tb_pessoa_id_pessoa   IN TB_VETERINARIO.TB_PESSOA_ID_PESSOA%TYPE
) AS
BEGIN
    INSERT INTO TB_VETERINARIO (
        ID_VETERINARIO, CRMV_VETERINARIO, TB_USUARIO_ID_USUARIO, TB_PESSOA_ID_PESSOA
    ) VALUES (
        p_id_veterinario, p_crmv_veterinario, p_tb_usuario_id_usuario, p_tb_pessoa_id_pessoa
    );
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        SP_REGISTRA_LOG('SP_INS_VETERINARIO', SQLCODE, 'Registro duplicado: ' || SQLERRM);
        RAISE;
    WHEN NO_DATA_FOUND THEN
        SP_REGISTRA_LOG('SP_INS_VETERINARIO', SQLCODE, 'FK nao encontrada: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('SP_INS_VETERINARIO', SQLCODE, SQLERRM);
        RAISE;
END SP_INS_VETERINARIO;
/

-- ============================================================
-- 7. TB_VETERINARIO_ESPECIALIDADE
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INS_VET_ESPECIALIDADE (
    p_id_especialidade_veterinario  IN TB_VETERINARIO_ESPECIALIDADE.ID_ESPECIALIDADE_VETERINARIO%TYPE,
    p_tb_veterinario_id_veterinario IN TB_VETERINARIO_ESPECIALIDADE.TB_VETERINARIO_ID_VETERINARIO%TYPE,
    p_tb_espcd_vet_id_espcd_vet     IN TB_VETERINARIO_ESPECIALIDADE.TB_ESPCD_VET_ID_ESPCD_VET%TYPE
) AS
BEGIN
    INSERT INTO TB_VETERINARIO_ESPECIALIDADE (
        ID_ESPECIALIDADE_VETERINARIO, TB_VETERINARIO_ID_VETERINARIO, TB_ESPCD_VET_ID_ESPCD_VET
    ) VALUES (
        p_id_especialidade_veterinario, p_tb_veterinario_id_veterinario, p_tb_espcd_vet_id_espcd_vet
    );
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        SP_REGISTRA_LOG('SP_INS_VET_ESPECIALIDADE', SQLCODE, 'Registro duplicado: ' || SQLERRM);
        RAISE;
    WHEN NO_DATA_FOUND THEN
        SP_REGISTRA_LOG('SP_INS_VET_ESPECIALIDADE', SQLCODE, 'FK nao encontrada: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('SP_INS_VET_ESPECIALIDADE', SQLCODE, SQLERRM);
        RAISE;
END SP_INS_VET_ESPECIALIDADE;
/

-- ============================================================
-- 8. TB_VETERINARIO_ESPECIE
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INS_VET_ESPECIE (
    p_id_veterinario_especie        IN TB_VETERINARIO_ESPECIE.ID_VETERINARIO_ESPECIE%TYPE,
    p_tb_veterinario_id_veterinario IN TB_VETERINARIO_ESPECIE.TB_VETERINARIO_ID_VETERINARIO%TYPE,
    p_tb_especie_id_especie         IN TB_VETERINARIO_ESPECIE.TB_ESPECIE_ID_ESPECIE%TYPE
) AS
BEGIN
    INSERT INTO TB_VETERINARIO_ESPECIE (
        ID_VETERINARIO_ESPECIE, TB_VETERINARIO_ID_VETERINARIO, TB_ESPECIE_ID_ESPECIE
    ) VALUES (
        p_id_veterinario_especie, p_tb_veterinario_id_veterinario, p_tb_especie_id_especie
    );
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        SP_REGISTRA_LOG('SP_INS_VET_ESPECIE', SQLCODE, 'Registro duplicado: ' || SQLERRM);
        RAISE;
    WHEN NO_DATA_FOUND THEN
        SP_REGISTRA_LOG('SP_INS_VET_ESPECIE', SQLCODE, 'FK nao encontrada: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('SP_INS_VET_ESPECIE', SQLCODE, SQLERRM);
        RAISE;
END SP_INS_VET_ESPECIE;
/

-- ============================================================
-- 9. TB_ANIMAL
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INS_ANIMAL (
    p_id_animal             IN TB_ANIMAL.ID_ANIMAL%TYPE,
    p_nm_animal             IN TB_ANIMAL.NM_ANIMAL%TYPE,
    p_rc_animal             IN TB_ANIMAL.RC_ANIMAL%TYPE,
    p_sx_animal             IN TB_ANIMAL.SX_ANIMAL%TYPE,
    p_dt_nasc_animal        IN TB_ANIMAL.DT_NASC_ANIMAL%TYPE,
    p_nr_peso_animal        IN TB_ANIMAL.NR_PESO_ANIMAL%TYPE,
    p_tb_tutor_id_tutor     IN TB_ANIMAL.TB_TUTOR_ID_TUTOR%TYPE,
    p_tb_especie_id_especie IN TB_ANIMAL.TB_ESPECIE_ID_ESPECIE%TYPE
) AS
BEGIN
    INSERT INTO TB_ANIMAL (
        ID_ANIMAL, NM_ANIMAL, RC_ANIMAL, SX_ANIMAL, DT_NASC_ANIMAL,
        NR_PESO_ANIMAL, TB_TUTOR_ID_TUTOR, TB_ESPECIE_ID_ESPECIE
    ) VALUES (
        p_id_animal, p_nm_animal, p_rc_animal, p_sx_animal, p_dt_nasc_animal,
        p_nr_peso_animal, p_tb_tutor_id_tutor, p_tb_especie_id_especie
    );
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        SP_REGISTRA_LOG('SP_INS_ANIMAL', SQLCODE, 'Registro duplicado: ' || SQLERRM);
        RAISE;
    WHEN VALUE_ERROR THEN
        SP_REGISTRA_LOG('SP_INS_ANIMAL', SQLCODE, 'Erro de valor/tipo: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('SP_INS_ANIMAL', SQLCODE, SQLERRM);
        RAISE;
END SP_INS_ANIMAL;
/

-- ============================================================
-- 10. TB_PRONTUARIO
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INS_PRONTUARIO (
    p_id_prontuario         IN TB_PRONTUARIO.ID_PRONTUARIO%TYPE,
    p_dt_upd_pronturario    IN TB_PRONTUARIO.DT_UPD_PRONTURARIO%TYPE,
    p_tb_animal_id_animal   IN TB_PRONTUARIO.TB_ANIMAL_ID_ANIMAL%TYPE
) AS
BEGIN
    INSERT INTO TB_PRONTUARIO (
        ID_PRONTUARIO, DT_UPD_PRONTURARIO, TB_ANIMAL_ID_ANIMAL
    ) VALUES (
        p_id_prontuario, p_dt_upd_pronturario, p_tb_animal_id_animal
    );
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        SP_REGISTRA_LOG('SP_INS_PRONTUARIO', SQLCODE, 'Registro duplicado: ' || SQLERRM);
        RAISE;
    WHEN NO_DATA_FOUND THEN
        SP_REGISTRA_LOG('SP_INS_PRONTUARIO', SQLCODE, 'FK nao encontrada: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('SP_INS_PRONTUARIO', SQLCODE, SQLERRM);
        RAISE;
END SP_INS_PRONTUARIO;
/

-- ============================================================
-- 11. TB_CONSULTA
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INS_CONSULTA (
    p_id_consulta                   IN TB_CONSULTA.ID_CONSULTA%TYPE,
    p_dt_hr_consulta                IN TB_CONSULTA.DT_HR_CONSULTA%TYPE,
    p_st_consulta                   IN TB_CONSULTA.ST_CONSULTA%TYPE,
    p_vl_consulta                   IN TB_CONSULTA.VL_CONSULTA%TYPE,
    p_obs_consulta                  IN TB_CONSULTA.OBS_CONSULTA%TYPE,
    p_tb_veterinario_id_veterinario IN TB_CONSULTA.TB_VETERINARIO_ID_VETERINARIO%TYPE,
    p_tb_animal_id_animal           IN TB_CONSULTA.TB_ANIMAL_ID_ANIMAL%TYPE
) AS
BEGIN
    INSERT INTO TB_CONSULTA (
        ID_CONSULTA, DT_HR_CONSULTA, ST_CONSULTA, VL_CONSULTA, OBS_CONSULTA,
        TB_VETERINARIO_ID_VETERINARIO, TB_ANIMAL_ID_ANIMAL
    ) VALUES (
        p_id_consulta, p_dt_hr_consulta, p_st_consulta, p_vl_consulta, p_obs_consulta,
        p_tb_veterinario_id_veterinario, p_tb_animal_id_animal
    );
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        SP_REGISTRA_LOG('SP_INS_CONSULTA', SQLCODE, 'Registro duplicado: ' || SQLERRM);
        RAISE;
    WHEN VALUE_ERROR THEN
        SP_REGISTRA_LOG('SP_INS_CONSULTA', SQLCODE, 'Erro de valor/tipo: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('SP_INS_CONSULTA', SQLCODE, SQLERRM);
        RAISE;
END SP_INS_CONSULTA;
/

-- ============================================================
-- 12. TB_EVOLUCAO_CLINICA
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INS_EVOLUCAO_CLINICA (
    p_id_evolucao_clinica   IN TB_EVOLUCAO_CLINICA.ID_EVOLUCAO_CLINICA%TYPE,
    p_ant_evolucao_clinica  IN TB_EVOLUCAO_CLINICA.ANT_EVOLUCAO_CLINICA%TYPE,
    p_tb_consulta_id_consulta IN TB_EVOLUCAO_CLINICA.TB_CONSULTA_ID_CONSULTA%TYPE
) AS
BEGIN
    INSERT INTO TB_EVOLUCAO_CLINICA (
        ID_EVOLUCAO_CLINICA, ANT_EVOLUCAO_CLINICA, TB_CONSULTA_ID_CONSULTA
    ) VALUES (
        p_id_evolucao_clinica, p_ant_evolucao_clinica, p_tb_consulta_id_consulta
    );
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        SP_REGISTRA_LOG('SP_INS_EVOLUCAO_CLINICA', SQLCODE, 'Registro duplicado: ' || SQLERRM);
        RAISE;
    WHEN NO_DATA_FOUND THEN
        SP_REGISTRA_LOG('SP_INS_EVOLUCAO_CLINICA', SQLCODE, 'FK nao encontrada: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('SP_INS_EVOLUCAO_CLINICA', SQLCODE, SQLERRM);
        RAISE;
END SP_INS_EVOLUCAO_CLINICA;
/

-- ============================================================
-- 13. TB_SOLICITACAO_EXAME
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INS_SOLICITACAO_EXAME (
    p_id_solicitacao_exame  IN TB_SOLICITACAO_EXAME.ID_SOLICITACAO_EXAME%TYPE,
    p_obs_solicitacao       IN TB_SOLICITACAO_EXAME.OBS_SOLICITACAO%TYPE,
    p_tb_consulta_id_consulta IN TB_SOLICITACAO_EXAME.TB_CONSULTA_ID_CONSULTA%TYPE
) AS
BEGIN
    INSERT INTO TB_SOLICITACAO_EXAME (
        ID_SOLICITACAO_EXAME, OBS_SOLICITACAO, TB_CONSULTA_ID_CONSULTA
    ) VALUES (
        p_id_solicitacao_exame, p_obs_solicitacao, p_tb_consulta_id_consulta
    );
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        SP_REGISTRA_LOG('SP_INS_SOLICITACAO_EXAME', SQLCODE, 'Registro duplicado: ' || SQLERRM);
        RAISE;
    WHEN NO_DATA_FOUND THEN
        SP_REGISTRA_LOG('SP_INS_SOLICITACAO_EXAME', SQLCODE, 'FK nao encontrada: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('SP_INS_SOLICITACAO_EXAME', SQLCODE, SQLERRM);
        RAISE;
END SP_INS_SOLICITACAO_EXAME;
/

-- ============================================================
-- 14. TB_SOLICITACAO_EXAME_ITEM
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INS_SOLICITACAO_EXAME_ITEM (
    p_id_solicitacao_exame_item     IN TB_SOLICITACAO_EXAME_ITEM.ID_SOLICITACAO_EXAME_ITEM%TYPE,
    p_nm_exame                      IN TB_SOLICITACAO_EXAME_ITEM.NM_EXAME%TYPE,
    p_st_exame                      IN TB_SOLICITACAO_EXAME_ITEM.ST_EXAME%TYPE,
    p_dt_solc_exame                 IN TB_SOLICITACAO_EXAME_ITEM.DT_SOLC_EXAME%TYPE,
    p_dt_res_exame                  IN TB_SOLICITACAO_EXAME_ITEM.DT_RES_EXAME%TYPE,
    p_ds_res_exame                  IN TB_SOLICITACAO_EXAME_ITEM.DS_RES_EXAME%TYPE,
    p_dt_analise                    IN TB_SOLICITACAO_EXAME_ITEM.DT_ANALISE%TYPE,
    p_dt_envio_resultado            IN TB_SOLICITACAO_EXAME_ITEM.DT_ENVIO_RESULTADO%TYPE,
    p_tb_solct_exame_id_solct_exame IN TB_SOLICITACAO_EXAME_ITEM.TB_SOLCT_EXAME_ID_SOLCT_EXAME%TYPE
) AS
BEGIN
    INSERT INTO TB_SOLICITACAO_EXAME_ITEM (
        ID_SOLICITACAO_EXAME_ITEM, NM_EXAME, ST_EXAME, DT_SOLC_EXAME,
        DT_RES_EXAME, DS_RES_EXAME, DT_ANALISE, DT_ENVIO_RESULTADO,
        TB_SOLCT_EXAME_ID_SOLCT_EXAME
    ) VALUES (
        p_id_solicitacao_exame_item, p_nm_exame, p_st_exame, p_dt_solc_exame,
        p_dt_res_exame, p_ds_res_exame, p_dt_analise, p_dt_envio_resultado,
        p_tb_solct_exame_id_solct_exame
    );
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        SP_REGISTRA_LOG('SP_INS_SOLICITACAO_EXAME_ITEM', SQLCODE, 'Registro duplicado: ' || SQLERRM);
        RAISE;
    WHEN VALUE_ERROR THEN
        SP_REGISTRA_LOG('SP_INS_SOLICITACAO_EXAME_ITEM', SQLCODE, 'Erro de valor/tipo: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('SP_INS_SOLICITACAO_EXAME_ITEM', SQLCODE, SQLERRM);
        RAISE;
END SP_INS_SOLICITACAO_EXAME_ITEM;
/

-- ============================================================
-- 15. TB_ANEXO_EXAME
-- ============================================================
CREATE OR REPLACE PROCEDURE SP_INS_ANEXO_EXAME (
    p_id_anexo_exame                IN TB_ANEXO_EXAME.ID_ANEXO_EXAME%TYPE,
    p_url_arquivo_anexo             IN TB_ANEXO_EXAME.URL_ARQUIVO_ANEXO%TYPE,
    p_mime_type_anexo               IN TB_ANEXO_EXAME.MIME_TYPE_ANEXO%TYPE,
    p_dt_upload_anexo               IN TB_ANEXO_EXAME.DT_UPLOAD_ANEXO%TYPE,
    p_tb_slc_ex_item_id_slc_ex_item IN TB_ANEXO_EXAME.TB_SLC_EX_ITEM_ID_SLC_EX_ITEM%TYPE
) AS
BEGIN
    INSERT INTO TB_ANEXO_EXAME (
        ID_ANEXO_EXAME, URL_ARQUIVO_ANEXO, MIME_TYPE_ANEXO, DT_UPLOAD_ANEXO,
        TB_SLC_EX_ITEM_ID_SLC_EX_ITEM
    ) VALUES (
        p_id_anexo_exame, p_url_arquivo_anexo, p_mime_type_anexo, p_dt_upload_anexo,
        p_tb_slc_ex_item_id_slc_ex_item
    );
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        SP_REGISTRA_LOG('SP_INS_ANEXO_EXAME', SQLCODE, 'Registro duplicado: ' || SQLERRM);
        RAISE;
    WHEN VALUE_ERROR THEN
        SP_REGISTRA_LOG('SP_INS_ANEXO_EXAME', SQLCODE, 'Erro de valor/tipo: ' || SQLERRM);
        RAISE;
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('SP_INS_ANEXO_EXAME', SQLCODE, SQLERRM);
        RAISE;
END SP_INS_ANEXO_EXAME;
/
