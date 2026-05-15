-- ============================================================
-- PROCEDURES DE CARGA DE DADOS - SISTEMA VETERINÁRIO
-- Gerado em: 14/05/2026
-- Banco: Oracle Database 11g
-- Descrição: Procedures parametrizadas para carga de dados
--            com tratamento de exceção e registro em LOG_ERRO
-- ============================================================


-- ============================================================
-- 1. PROCEDURE: PRC_INSERT_USUARIO
-- Tabela: TB_USUARIO
-- ============================================================
CREATE OR REPLACE PROCEDURE PRC_INSERT_USUARIO (
    p_id_usuario       IN TB_USUARIO.ID_USUARIO%TYPE,
    p_em_usuario       IN TB_USUARIO.EM_USUARIO%TYPE,
    p_rl_usuario       IN TB_USUARIO.RL_USUARIO%TYPE,
    p_fl_atv_usuario   IN TB_USUARIO.FL_ATV_USUARIO%TYPE,
    p_sen_hash_usuario IN TB_USUARIO.SEN_HASH_USUARIO%TYPE
)
AS
    -- Exceção personalizada: e-mail duplicado
    ex_email_duplicado EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_email_duplicado, -00001);

    -- Exceção personalizada: role inválida
    ex_role_invalida EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_role_invalida, -02290);

    v_count NUMBER;
BEGIN
    -- Verifica duplicidade de e-mail antes de inserir
    SELECT COUNT(1)
      INTO v_count
      FROM TB_USUARIO
     WHERE EM_USUARIO = p_em_usuario;

    IF v_count > 0 THEN
        RAISE ex_email_duplicado;
    END IF;

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
    WHEN ex_email_duplicado THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_USUARIO', USER, SYSDATE, -1, 'E-mail já cadastrado: ' || p_em_usuario);
        COMMIT;
        RAISE;

    WHEN ex_role_invalida THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_USUARIO', USER, SYSDATE, -2290, 'Role inválida informada: ' || p_rl_usuario || '. Valores aceitos: ADMIN, TUTOR, VETERINARIO');
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_USUARIO', USER, SYSDATE, SQLCODE, SQLERRM);
        COMMIT;
        RAISE;
END PRC_INSERT_USUARIO;
/


-- ============================================================
-- 2. PROCEDURE: PRC_INSERT_TUTOR
-- Tabela: TB_TUTOR
-- ============================================================
CREATE OR REPLACE PROCEDURE PRC_INSERT_TUTOR (
    p_id_tutor              IN TB_TUTOR.ID_TUTOR%TYPE,
    p_nm_tutor              IN TB_TUTOR.NM_TUTOR%TYPE,
    p_cpf_tutor             IN TB_TUTOR.CPF_TUTOR%TYPE,
    p_tel_tutor             IN TB_TUTOR.TEL_TUTOR%TYPE,
    p_tb_usuario_id_usuario IN TB_TUTOR.TB_USUARIO_ID_USUARIO%TYPE
)
AS
    -- Exceção personalizada: CPF duplicado
    ex_cpf_duplicado EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_cpf_duplicado, -00001);

    -- Exceção personalizada: FK de usuário inexistente
    ex_fk_usuario EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_fk_usuario, -02291);

    v_count NUMBER;
BEGIN
    -- Verifica se CPF já existe
    SELECT COUNT(1)
      INTO v_count
      FROM TB_TUTOR
     WHERE CPF_TUTOR = p_cpf_tutor;

    IF v_count > 0 THEN
        RAISE ex_cpf_duplicado;
    END IF;

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
    WHEN ex_cpf_duplicado THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_TUTOR', USER, SYSDATE, -1, 'CPF já cadastrado para outro tutor: ' || p_cpf_tutor);
        COMMIT;
        RAISE;

    WHEN ex_fk_usuario THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_TUTOR', USER, SYSDATE, -2291, 'ID_USUARIO não encontrado em TB_USUARIO: ' || p_tb_usuario_id_usuario);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_TUTOR', USER, SYSDATE, SQLCODE, SQLERRM);
        COMMIT;
        RAISE;
END PRC_INSERT_TUTOR;
/


-- ============================================================
-- 3. PROCEDURE: PRC_INSERT_ESPECIE
-- Tabela: TB_ESPECIE
-- ============================================================
CREATE OR REPLACE PROCEDURE PRC_INSERT_ESPECIE (
    p_id_especie IN TB_ESPECIE.ID_ESPECIE%TYPE,
    p_nm_especie IN TB_ESPECIE.NM_ESPECIE%TYPE
)
AS
    -- Exceção personalizada: espécie duplicada (UNIQUE)
    ex_especie_duplicada EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_especie_duplicada, -00001);

    -- Exceção personalizada: valor fora do CHECK constraint
    ex_especie_invalida EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_especie_invalida, -02290);

BEGIN
    INSERT INTO TB_ESPECIE (
        ID_ESPECIE,
        NM_ESPECIE
    ) VALUES (
        p_id_especie,
        p_nm_especie
    );

    COMMIT;

EXCEPTION
    WHEN ex_especie_duplicada THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_ESPECIE', USER, SYSDATE, -1, 'Espécie já cadastrada: ' || p_nm_especie);
        COMMIT;
        RAISE;

    WHEN ex_especie_invalida THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_ESPECIE', USER, SYSDATE, -2290, 'Espécie inválida: ' || p_nm_especie || '. Valores aceitos: ANFIBIO, AVE, CAO, EQUIDEO, GATO, MAMIFERO, PEIXE, REPTIL');
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_ESPECIE', USER, SYSDATE, SQLCODE, SQLERRM);
        COMMIT;
        RAISE;
END PRC_INSERT_ESPECIE;
/


-- ============================================================
-- 4. PROCEDURE: PRC_INSERT_ESPECIALIDADE_VET
-- Tabela: TB_ESPECIALIDADES_VET
-- ============================================================
CREATE OR REPLACE PROCEDURE PRC_INSERT_ESPECIALIDADE_VET (
    p_id_especialidade_vet IN TB_ESPECIALIDADES_VET.ID_ESPECIALIDADE_VET%TYPE,
    p_nm_especialidade     IN TB_ESPECIALIDADES_VET.NM_ESPECIALIDADE%TYPE,
    p_ds_especialidade     IN TB_ESPECIALIDADES_VET.DS_ESPECIALIDADE%TYPE
)
AS
    -- Exceção personalizada: especialidade duplicada (UNIQUE)
    ex_especialidade_duplicada EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_especialidade_duplicada, -00001);

    -- Exceção personalizada: valor fora do CHECK constraint
    ex_especialidade_invalida EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_especialidade_invalida, -02290);

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
    WHEN ex_especialidade_duplicada THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_ESPECIALIDADE_VET', USER, SYSDATE, -1, 'Especialidade já cadastrada: ' || p_nm_especialidade);
        COMMIT;
        RAISE;

    WHEN ex_especialidade_invalida THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_ESPECIALIDADE_VET', USER, SYSDATE, -2290, 'Especialidade inválida informada: ' || p_nm_especialidade || '. Consulte as especialidades oficiais do CRMV.');
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_ESPECIALIDADE_VET', USER, SYSDATE, SQLCODE, SQLERRM);
        COMMIT;
        RAISE;
END PRC_INSERT_ESPECIALIDADE_VET;
/


-- ============================================================
-- 5. PROCEDURE: PRC_INSERT_VETERINARIO
-- Tabela: TB_VETERINARIO
-- ============================================================
CREATE OR REPLACE PROCEDURE PRC_INSERT_VETERINARIO (
    p_id_veterinario        IN TB_VETERINARIO.ID_VETERINARIO%TYPE,
    p_nm_veterinario        IN TB_VETERINARIO.NM_VETERINARIO%TYPE,
    p_cpf_veterinario       IN TB_VETERINARIO.CPF_VETERINARIO%TYPE,
    p_crmv_veterinario      IN TB_VETERINARIO.CRMV_VETERINARIO%TYPE,
    p_tel_veterinario       IN TB_VETERINARIO.TEL_VETERINARIO%TYPE,
    p_uf_atd_veterinario    IN TB_VETERINARIO.UF_ATD_VETERINARIO%TYPE,
    p_tb_usuario_id_usuario IN TB_VETERINARIO.TB_USUARIO_ID_USUARIO%TYPE
)
AS
    -- Exceção personalizada: CRMV/CPF duplicado
    ex_crmv_duplicado EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_crmv_duplicado, -00001);

    -- Exceção personalizada: FK de usuário inexistente
    ex_fk_usuario EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_fk_usuario, -02291);

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
    WHEN ex_crmv_duplicado THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_VETERINARIO', USER, SYSDATE, -1, 'CPF, CRMV ou telefone já cadastrado para outro veterinário. CRMV informado: ' || p_crmv_veterinario);
        COMMIT;
        RAISE;

    WHEN ex_fk_usuario THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_VETERINARIO', USER, SYSDATE, -2291, 'ID_USUARIO não encontrado em TB_USUARIO: ' || p_tb_usuario_id_usuario);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_VETERINARIO', USER, SYSDATE, SQLCODE, SQLERRM);
        COMMIT;
        RAISE;
END PRC_INSERT_VETERINARIO;
/


-- ============================================================
-- 6. PROCEDURE: PRC_INSERT_VET_ESPECIALIDADE
-- Tabela: TB_VETERINARIO_ESPECIALIDADE
-- ============================================================
CREATE OR REPLACE PROCEDURE PRC_INSERT_VET_ESPECIALIDADE (
    p_id_especialidade_vet        IN TB_VETERINARIO_ESPECIALIDADE.ID_ESPECIALIDADE_VETERINARIO%TYPE,
    p_tb_veterinario_id_veterinario IN TB_VETERINARIO_ESPECIALIDADE.TB_VETERINARIO_ID_VETERINARIO%TYPE,
    p_tb_espcd_vet_id_espcd_vet   IN TB_VETERINARIO_ESPECIALIDADE.TB_ESPCD_VET_ID_ESPCD_VET%TYPE
)
AS
    -- Exceção personalizada: FK de veterinário inexistente
    ex_fk_veterinario EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_fk_veterinario, -02291);

    -- Exceção personalizada: vínculo duplicado (PK)
    ex_vinculo_duplicado EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_vinculo_duplicado, -00001);

BEGIN
    INSERT INTO TB_VETERINARIO_ESPECIALIDADE (
        ID_ESPECIALIDADE_VETERINARIO,
        TB_VETERINARIO_ID_VETERINARIO,
        TB_ESPCD_VET_ID_ESPCD_VET
    ) VALUES (
        p_id_especialidade_vet,
        p_tb_veterinario_id_veterinario,
        p_tb_espcd_vet_id_espcd_vet
    );

    COMMIT;

EXCEPTION
    WHEN ex_fk_veterinario THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_VET_ESPECIALIDADE', USER, SYSDATE, -2291, 'Veterinário ou especialidade não encontrados. ID_VET: ' || p_tb_veterinario_id_veterinario || ' | ID_ESPCD: ' || p_tb_espcd_vet_id_espcd_vet);
        COMMIT;
        RAISE;

    WHEN ex_vinculo_duplicado THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_VET_ESPECIALIDADE', USER, SYSDATE, -1, 'Vínculo já existente. ID_ESPECIALIDADE_VETERINARIO: ' || p_id_especialidade_vet);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_VET_ESPECIALIDADE', USER, SYSDATE, SQLCODE, SQLERRM);
        COMMIT;
        RAISE;
END PRC_INSERT_VET_ESPECIALIDADE;
/


-- ============================================================
-- 7. PROCEDURE: PRC_INSERT_VET_ESPECIE
-- Tabela: TB_VETERINARIO_ESPECIE
-- ============================================================
CREATE OR REPLACE PROCEDURE PRC_INSERT_VET_ESPECIE (
    p_id_veterinario_especie        IN TB_VETERINARIO_ESPECIE.ID_VETERINARIO_ESPECIE%TYPE,
    p_tb_veterinario_id_veterinario IN TB_VETERINARIO_ESPECIE.TB_VETERINARIO_ID_VETERINARIO%TYPE,
    p_tb_especie_id_especie         IN TB_VETERINARIO_ESPECIE.TB_ESPECIE_ID_ESPECIE%TYPE
)
AS
    -- Exceção personalizada: FK de veterinário ou espécie inexistente
    ex_fk_invalida EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_fk_invalida, -02291);

    -- Exceção personalizada: vínculo duplicado (PK)
    ex_vinculo_duplicado EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_vinculo_duplicado, -00001);

BEGIN
    INSERT INTO TB_VETERINARIO_ESPECIE (
        ID_VETERINARIO_ESPECIE,
        TB_VETERINARIO_ID_VETERINARIO,
        TB_ESPECIE_ID_ESPECIE
    ) VALUES (
        p_id_veterinario_especie,
        p_tb_veterinario_id_veterinario,
        p_tb_especie_id_especie
    );

    COMMIT;

EXCEPTION
    WHEN ex_fk_invalida THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_VET_ESPECIE', USER, SYSDATE, -2291, 'Veterinário ou espécie não encontrados. ID_VET: ' || p_tb_veterinario_id_veterinario || ' | ID_ESPECIE: ' || p_tb_especie_id_especie);
        COMMIT;
        RAISE;

    WHEN ex_vinculo_duplicado THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_VET_ESPECIE', USER, SYSDATE, -1, 'Vínculo veterinário-espécie já existente. ID: ' || p_id_veterinario_especie);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_VET_ESPECIE', USER, SYSDATE, SQLCODE, SQLERRM);
        COMMIT;
        RAISE;
END PRC_INSERT_VET_ESPECIE;
/


-- ============================================================
-- 8. PROCEDURE: PRC_INSERT_ANIMAL
-- Tabela: TB_ANIMAL
-- ============================================================
CREATE OR REPLACE PROCEDURE PRC_INSERT_ANIMAL (
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
    -- Exceção personalizada: sexo inválido (CHECK constraint)
    ex_sexo_invalido EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_sexo_invalido, -02290);

    -- Exceção personalizada: FK de tutor ou espécie inexistente
    ex_fk_invalida EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_fk_invalida, -02291);

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
    WHEN ex_sexo_invalido THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_ANIMAL', USER, SYSDATE, -2290, 'Sexo inválido informado: ' || p_sx_animal || '. Valores aceitos: F (Fêmea) ou M (Macho)');
        COMMIT;
        RAISE;

    WHEN ex_fk_invalida THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_ANIMAL', USER, SYSDATE, -2291, 'Tutor ou espécie não encontrados. ID_TUTOR: ' || p_tb_tutor_id_tutor || ' | ID_ESPECIE: ' || p_tb_especie_id_especie);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_ANIMAL', USER, SYSDATE, SQLCODE, SQLERRM);
        COMMIT;
        RAISE;
END PRC_INSERT_ANIMAL;
/


-- ============================================================
-- 9. PROCEDURE: PRC_INSERT_CONSULTA
-- Tabela: TB_CONSULTA
-- ============================================================
CREATE OR REPLACE PROCEDURE PRC_INSERT_CONSULTA (
    p_id_consulta                   IN TB_CONSULTA.ID_CONSULTA%TYPE,
    p_dt_hr_consulta                IN TB_CONSULTA.DT_HR_CONSULTA%TYPE,
    p_st_consulta                   IN TB_CONSULTA.ST_CONSULTA%TYPE,
    p_vl_consulta                   IN TB_CONSULTA.VL_CONSULTA%TYPE,
    p_obs_consulta                  IN TB_CONSULTA.OBS_CONSULTA%TYPE,
    p_tb_veterinario_id_veterinario IN TB_CONSULTA.TB_VETERINARIO_ID_VETERINARIO%TYPE,
    p_tb_animal_id_animal           IN TB_CONSULTA.TB_ANIMAL_ID_ANIMAL%TYPE
)
AS
    -- Exceção personalizada: status inválido (CHECK constraint)
    ex_status_invalido EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_status_invalido, -02290);

    -- Exceção personalizada: FK de veterinário ou animal inexistente
    ex_fk_invalida EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_fk_invalida, -02291);

BEGIN
    -- Validação de valor negativo ou zero antes de inserir
    IF p_vl_consulta <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Valor da consulta deve ser maior que zero. Valor informado: ' || p_vl_consulta);
    END IF;

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
    WHEN ex_status_invalido THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_CONSULTA', USER, SYSDATE, -2290, 'Status inválido: ' || p_st_consulta || '. Valores aceitos: AGENDADA, CANCELADA, REALIZADA');
        COMMIT;
        RAISE;

    WHEN ex_fk_invalida THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_CONSULTA', USER, SYSDATE, -2291, 'Veterinário ou animal não encontrados. ID_VET: ' || p_tb_veterinario_id_veterinario || ' | ID_ANIMAL: ' || p_tb_animal_id_animal);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_CONSULTA', USER, SYSDATE, SQLCODE, SQLERRM);
        COMMIT;
        RAISE;
END PRC_INSERT_CONSULTA;
/


-- ============================================================
-- 10. PROCEDURE: PRC_INSERT_PRONTUARIO
-- Tabela: TB_PRONTUARIO
-- ============================================================
CREATE OR REPLACE PROCEDURE PRC_INSERT_PRONTUARIO (
    p_id_prontuario       IN TB_PRONTUARIO.ID_PRONTUARIO%TYPE,
    p_dt_upd_pronturario  IN TB_PRONTUARIO.DT_UPD_PRONTURARIO%TYPE,
    p_tb_animal_id_animal IN TB_PRONTUARIO.TB_ANIMAL_ID_ANIMAL%TYPE
)
AS
    -- Exceção personalizada: animal já possui prontuário (UNIQUE INDEX)
    ex_prontuario_duplicado EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_prontuario_duplicado, -00001);

    -- Exceção personalizada: FK de animal inexistente
    ex_fk_animal EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_fk_animal, -02291);

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
    WHEN ex_prontuario_duplicado THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_PRONTUARIO', USER, SYSDATE, -1, 'Animal já possui prontuário cadastrado. ID_ANIMAL: ' || p_tb_animal_id_animal);
        COMMIT;
        RAISE;

    WHEN ex_fk_animal THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_PRONTUARIO', USER, SYSDATE, -2291, 'Animal não encontrado. ID_ANIMAL: ' || p_tb_animal_id_animal);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_PRONTUARIO', USER, SYSDATE, SQLCODE, SQLERRM);
        COMMIT;
        RAISE;
END PRC_INSERT_PRONTUARIO;
/


-- ============================================================
-- 11. PROCEDURE: PRC_INSERT_EVOLUCAO_CLINICA
-- Tabela: TB_EVOLUCAO_CLINICA
-- ============================================================
CREATE OR REPLACE PROCEDURE PRC_INSERT_EVOLUCAO_CLINICA (
    p_id_evolucao_clinica         IN TB_EVOLUCAO_CLINICA.ID_EVOLUCAO_CLINICA%TYPE,
    p_ant_evolucao_clinica        IN TB_EVOLUCAO_CLINICA.ANT_EVOLUCAO_CLINICA%TYPE,
    p_tb_consulta_id_consulta     IN TB_EVOLUCAO_CLINICA.TB_CONSULTA_ID_CONSULTA%TYPE,
    p_tb_prontuario_id_prontuario IN TB_EVOLUCAO_CLINICA.TB_PRONTUARIO_ID_PRONTUARIO%TYPE
)
AS
    -- Exceção personalizada: consulta já possui evolução (UNIQUE INDEX)
    ex_evolucao_duplicada EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_evolucao_duplicada, -00001);

    -- Exceção personalizada: FK de consulta ou prontuário inexistente
    ex_fk_invalida EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_fk_invalida, -02291);

BEGIN
    -- Valida que anotação não está vazia
    IF p_ant_evolucao_clinica IS NULL OR TRIM(p_ant_evolucao_clinica) IS NULL THEN
        RAISE_APPLICATION_ERROR(-20002, 'Anotação da evolução clínica não pode ser vazia.');
    END IF;

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
    WHEN ex_evolucao_duplicada THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_EVOLUCAO_CLINICA', USER, SYSDATE, -1, 'Consulta já possui evolução clínica registrada. ID_CONSULTA: ' || p_tb_consulta_id_consulta);
        COMMIT;
        RAISE;

    WHEN ex_fk_invalida THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_EVOLUCAO_CLINICA', USER, SYSDATE, -2291, 'Consulta ou prontuário não encontrados. ID_CONSULTA: ' || p_tb_consulta_id_consulta || ' | ID_PRONTUARIO: ' || p_tb_prontuario_id_prontuario);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_EVOLUCAO_CLINICA', USER, SYSDATE, SQLCODE, SQLERRM);
        COMMIT;
        RAISE;
END PRC_INSERT_EVOLUCAO_CLINICA;
/


-- ============================================================
-- 12. PROCEDURE: PRC_INSERT_EXAME
-- Tabela: TB_EXAME
-- ============================================================
CREATE OR REPLACE PROCEDURE PRC_INSERT_EXAME (
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
    -- Exceção personalizada: FK de consulta, prontuário ou animal inexistente
    ex_fk_invalida EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_fk_invalida, -02291);

    -- Exceção personalizada: data de resultado no futuro
    ex_data_invalida EXCEPTION;

BEGIN
    -- Valida que a data do resultado não é futura
    IF p_dt_res_exame > SYSDATE THEN
        RAISE ex_data_invalida;
    END IF;

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
    WHEN ex_data_invalida THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_EXAME', USER, SYSDATE, -20003, 'Data de resultado do exame não pode ser futura. Data informada: ' || TO_CHAR(p_dt_res_exame, 'DD/MM/YYYY'));
        COMMIT;
        RAISE_APPLICATION_ERROR(-20003, 'Data de resultado do exame não pode ser futura.');

    WHEN ex_fk_invalida THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_EXAME', USER, SYSDATE, -2291, 'Consulta, prontuário ou animal não encontrados. ID_CONSULTA: ' || p_tb_consulta_id_consulta || ' | ID_ANIMAL: ' || p_tb_animal_id_animal);
        COMMIT;
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO LOG_ERRO (NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA, CODIGO_ERRO, MENSAGEM_ERRO)
        VALUES ('PRC_INSERT_EXAME', USER, SYSDATE, SQLCODE, SQLERRM);
        COMMIT;
        RAISE;
END PRC_INSERT_EXAME;
/


-- ============================================================
-- FIM DO SCRIPT
-- Total de procedures criadas: 12
-- Todas as procedures registram erros em LOG_ERRO com:
--   NOME_PROCEDURE, USUARIO_BANCO, DATA_OCORRENCIA,
--   CODIGO_ERRO, MENSAGEM_ERRO
-- ============================================================
