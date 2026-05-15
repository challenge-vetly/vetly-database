-- ============================================================
-- SCRIPT DE TESTES - PROCEDURES DE CARGA DE DADOS
-- Sistema Veterinário
-- Gerado em: 14/05/2026
-- ============================================================
-- INSTRUÇÕES:
--   Execute os blocos na ordem apresentada, pois os testes
--   de caminho feliz criam os dados que as tabelas filhas
--   precisam como FK.
--   Cada bloco de erro está envolvido em EXCEPTION para que
--   o script continue rodando após o erro esperado.
--   Ao final, consulte LOG_ERRO para verificar os registros.
-- ============================================================


-- ============================================================
-- LIMPEZA INICIAL (use apenas em ambiente de desenvolvimento)
-- ============================================================
/*
DELETE FROM TB_EXAME;
DELETE FROM TB_EVOLUCAO_CLINICA;
DELETE FROM TB_PRONTUARIO;
DELETE FROM TB_CONSULTA;
DELETE FROM TB_ANIMAL;
DELETE FROM TB_VETERINARIO_ESPECIE;
DELETE FROM TB_VETERINARIO_ESPECIALIDADE;
DELETE FROM TB_VETERINARIO;
DELETE FROM TB_TUTOR;
DELETE FROM TB_ESPECIE;
DELETE FROM TB_ESPECIALIDADES_VET;
DELETE FROM TB_USUARIO;
DELETE FROM LOG_ERRO;
COMMIT;
*/


-- ============================================================
-- TB_USUARIO | PRC_INSERT_USUARIO
-- Exceções:
--   1. ex_email_duplicado  (ORA-00001 - UNIQUE em EM_USUARIO)
--   2. ex_role_invalida    (ORA-02290 - CHECK em RL_USUARIO)
--   3. WHEN OTHERS         (ID nulo - NOT NULL em ID_USUARIO)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    PRC_INSERT_USUARIO(
        p_id_usuario       => 1,
        p_em_usuario       => 'joao.tutor@email.com',
        p_rl_usuario       => 'TUTOR',
        p_fl_atv_usuario   => 'S',
        p_sen_hash_usuario => '$2b$12$hashdojoao'
    );
    DBMS_OUTPUT.PUT_LINE('[OK] PRC_INSERT_USUARIO - caminho feliz');
END;
/

-- [ERRO 1] E-mail duplicado
BEGIN
    PRC_INSERT_USUARIO(
        p_id_usuario       => 2,
        p_em_usuario       => 'joao.tutor@email.com',  -- já existe
        p_rl_usuario       => 'ADMIN',
        p_fl_atv_usuario   => 'S',
        p_sen_hash_usuario => '$2b$12$hashoutro'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_USUARIO - email duplicado: ' || SQLERRM);
END;
/

-- [ERRO 2] Role fora do CHECK constraint
BEGIN
    PRC_INSERT_USUARIO(
        p_id_usuario       => 3,
        p_em_usuario       => 'invalido@email.com',
        p_rl_usuario       => 'GERENTE',               -- não está no CHECK
        p_fl_atv_usuario   => 'S',
        p_sen_hash_usuario => '$2b$12$hashinvalido'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_USUARIO - role invalida: ' || SQLERRM);
END;
/

-- [ERRO 3] WHEN OTHERS - ID nulo (violação de NOT NULL)
BEGIN
    PRC_INSERT_USUARIO(
        p_id_usuario       => NULL,                    -- NOT NULL violado
        p_em_usuario       => 'outro@email.com',
        p_rl_usuario       => 'ADMIN',
        p_fl_atv_usuario   => 'S',
        p_sen_hash_usuario => '$2b$12$hash'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_USUARIO - OTHERS id nulo: ' || SQLERRM);
END;
/

-- Insere usuário extra para ser usado pelo veterinário
BEGIN
    PRC_INSERT_USUARIO(
        p_id_usuario       => 10,
        p_em_usuario       => 'vet.carlos@email.com',
        p_rl_usuario       => 'VETERINARIO',
        p_fl_atv_usuario   => 'S',
        p_sen_hash_usuario => '$2b$12$hashvet'
    );
END;
/


-- ============================================================
-- TB_TUTOR | PRC_INSERT_TUTOR
-- Exceções:
--   1. ex_cpf_duplicado  (ORA-00001 - UNIQUE em CPF_TUTOR)
--   2. ex_fk_usuario     (ORA-02291 - FK TB_USUARIO_ID_USUARIO)
--   3. WHEN OTHERS       (nome excedendo tamanho da coluna)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    PRC_INSERT_TUTOR(
        p_id_tutor              => 1,
        p_nm_tutor              => 'João da Silva',
        p_cpf_tutor             => '12345678901',
        p_tel_tutor             => '11987654321',
        p_tb_usuario_id_usuario => 1
    );
    DBMS_OUTPUT.PUT_LINE('[OK] PRC_INSERT_TUTOR - caminho feliz');
END;
/

-- [ERRO 1] CPF duplicado
BEGIN
    PRC_INSERT_TUTOR(
        p_id_tutor              => 2,
        p_nm_tutor              => 'João Clone',
        p_cpf_tutor             => '12345678901',      -- CPF já cadastrado
        p_tel_tutor             => '11911111111',
        p_tb_usuario_id_usuario => 10
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_TUTOR - cpf duplicado: ' || SQLERRM);
END;
/

-- [ERRO 2] FK de usuário inexistente
BEGIN
    PRC_INSERT_TUTOR(
        p_id_tutor              => 3,
        p_nm_tutor              => 'Maria Souza',
        p_cpf_tutor             => '98765432100',
        p_tel_tutor             => '11922222222',
        p_tb_usuario_id_usuario => 9999               -- usuário inexistente
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_TUTOR - fk usuario invalida: ' || SQLERRM);
END;
/

-- [ERRO 3] WHEN OTHERS - nome maior que 100 caracteres
BEGIN
    PRC_INSERT_TUTOR(
        p_id_tutor              => 4,
        p_nm_tutor              => RPAD('X', 200, 'X'), -- coluna aceita só 100
        p_cpf_tutor             => '11111111111',
        p_tel_tutor             => '11933333333',
        p_tb_usuario_id_usuario => 1
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_TUTOR - OTHERS nome longo: ' || SQLERRM);
END;
/


-- ============================================================
-- TB_ESPECIE | PRC_INSERT_ESPECIE
-- Exceções:
--   1. ex_especie_duplicada  (ORA-00001 - UNIQUE em NM_ESPECIE)
--   2. ex_especie_invalida   (ORA-02290 - CHECK em NM_ESPECIE)
--   3. WHEN OTHERS           (ID duplicado - violação de PK)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    PRC_INSERT_ESPECIE(
        p_id_especie => 1,
        p_nm_especie => 'CAO'
    );
    DBMS_OUTPUT.PUT_LINE('[OK] PRC_INSERT_ESPECIE - caminho feliz');
END;
/

-- [ERRO 1] Nome de espécie duplicado (UNIQUE)
BEGIN
    PRC_INSERT_ESPECIE(
        p_id_especie => 2,
        p_nm_especie => 'CAO'                          -- já inserido acima
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_ESPECIE - especie duplicada: ' || SQLERRM);
END;
/

-- [ERRO 2] Espécie fora do CHECK constraint
BEGIN
    PRC_INSERT_ESPECIE(
        p_id_especie => 3,
        p_nm_especie => 'DINOSSAURO'                   -- não está no CHECK
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_ESPECIE - especie invalida check: ' || SQLERRM);
END;
/

-- [ERRO 3] WHEN OTHERS - ID de PK duplicado
BEGIN
    PRC_INSERT_ESPECIE(
        p_id_especie => 1,                             -- PK já existe
        p_nm_especie => 'GATO'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_ESPECIE - OTHERS pk duplicada: ' || SQLERRM);
END;
/

-- Insere espécies extras para os testes seguintes
BEGIN PRC_INSERT_ESPECIE(p_id_especie => 2, p_nm_especie => 'GATO'); END;
/
BEGIN PRC_INSERT_ESPECIE(p_id_especie => 3, p_nm_especie => 'AVE');  END;
/


-- ============================================================
-- TB_ESPECIALIDADES_VET | PRC_INSERT_ESPECIALIDADE_VET
-- Exceções:
--   1. ex_especialidade_duplicada  (ORA-00001 - UNIQUE NM_ESPECIALIDADE)
--   2. ex_especialidade_invalida   (ORA-02290 - CHECK NM_ESPECIALIDADE)
--   3. WHEN OTHERS                 (descrição nula - NOT NULL)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    PRC_INSERT_ESPECIALIDADE_VET(
        p_id_especialidade_vet => 1,
        p_nm_especialidade     => 'CARDIOLOGIA',
        p_ds_especialidade     => 'Diagnóstico e tratamento de doenças cardiovasculares em animais'
    );
    DBMS_OUTPUT.PUT_LINE('[OK] PRC_INSERT_ESPECIALIDADE_VET - caminho feliz');
END;
/

-- [ERRO 1] Nome de especialidade duplicado (UNIQUE)
BEGIN
    PRC_INSERT_ESPECIALIDADE_VET(
        p_id_especialidade_vet => 2,
        p_nm_especialidade     => 'CARDIOLOGIA',       -- já inserida acima
        p_ds_especialidade     => 'Outra descrição'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_ESPECIALIDADE_VET - duplicada: ' || SQLERRM);
END;
/

-- [ERRO 2] Especialidade fora do CHECK (valores CRMV)
BEGIN
    PRC_INSERT_ESPECIALIDADE_VET(
        p_id_especialidade_vet => 3,
        p_nm_especialidade     => 'PSICOLOGIA',        -- não reconhecida pelo CRMV
        p_ds_especialidade     => 'Especialidade inválida'
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_ESPECIALIDADE_VET - check invalido: ' || SQLERRM);
END;
/

-- [ERRO 3] WHEN OTHERS - descrição nula (NOT NULL)
BEGIN
    PRC_INSERT_ESPECIALIDADE_VET(
        p_id_especialidade_vet => 4,
        p_nm_especialidade     => 'NEUROLOGIA',
        p_ds_especialidade     => NULL                 -- NOT NULL violado
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_ESPECIALIDADE_VET - OTHERS descricao nula: ' || SQLERRM);
END;
/

-- Insere especialidade extra para os testes seguintes
BEGIN
    PRC_INSERT_ESPECIALIDADE_VET(
        p_id_especialidade_vet => 2,
        p_nm_especialidade     => 'CIRURGIA',
        p_ds_especialidade     => 'Procedimentos cirúrgicos em animais de pequeno e grande porte'
    );
END;
/


-- ============================================================
-- TB_VETERINARIO | PRC_INSERT_VETERINARIO
-- Exceções:
--   1. ex_crmv_duplicado  (ORA-00001 - UNIQUE CPF/CRMV/TEL)
--   2. ex_fk_usuario      (ORA-02291 - FK TB_USUARIO_ID_USUARIO)
--   3. WHEN OTHERS        (UF com mais de 2 caracteres)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    PRC_INSERT_VETERINARIO(
        p_id_veterinario        => 1,
        p_nm_veterinario        => 'Dr. Carlos Silva',
        p_cpf_veterinario       => '55566677788',
        p_crmv_veterinario      => 'CRMV-SP 12345',
        p_tel_veterinario       => '11944444444',
        p_uf_atd_veterinario    => 'SP',
        p_tb_usuario_id_usuario => 10
    );
    DBMS_OUTPUT.PUT_LINE('[OK] PRC_INSERT_VETERINARIO - caminho feliz');
END;
/

-- [ERRO 1] CPF + CRMV + Tel duplicados (UNIQUE composto)
BEGIN
    PRC_INSERT_VETERINARIO(
        p_id_veterinario        => 2,
        p_nm_veterinario        => 'Dr. Carlos Clone',
        p_cpf_veterinario       => '55566677788',      -- CPF duplicado
        p_crmv_veterinario      => 'CRMV-SP 12345',   -- CRMV duplicado
        p_tel_veterinario       => '11944444444',      -- Tel duplicado
        p_uf_atd_veterinario    => 'SP',
        p_tb_usuario_id_usuario => 10
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_VETERINARIO - crmv/cpf duplicado: ' || SQLERRM);
END;
/

-- [ERRO 2] FK de usuário inexistente
BEGIN
    PRC_INSERT_VETERINARIO(
        p_id_veterinario        => 3,
        p_nm_veterinario        => 'Dra. Ana Lima',
        p_cpf_veterinario       => '11122233344',
        p_crmv_veterinario      => 'CRMV-RJ 99999',
        p_tel_veterinario       => '21955555555',
        p_uf_atd_veterinario    => 'RJ',
        p_tb_usuario_id_usuario => 8888               -- usuário inexistente
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_VETERINARIO - fk usuario invalida: ' || SQLERRM);
END;
/

-- [ERRO 3] WHEN OTHERS - UF com mais de 2 caracteres
BEGIN
    PRC_INSERT_VETERINARIO(
        p_id_veterinario        => 4,
        p_nm_veterinario        => 'Dr. Teste',
        p_cpf_veterinario       => '33344455566',
        p_crmv_veterinario      => 'CRMV-MG 00001',
        p_tel_veterinario       => '31966666666',
        p_uf_atd_veterinario    => 'SPP',              -- coluna CHAR(2), excede tamanho
        p_tb_usuario_id_usuario => 10
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_VETERINARIO - OTHERS uf invalida: ' || SQLERRM);
END;
/


-- ============================================================
-- TB_VETERINARIO_ESPECIALIDADE | PRC_INSERT_VET_ESPECIALIDADE
-- Exceções:
--   1. ex_vinculo_duplicado  (ORA-00001 - PK duplicada)
--   2. ex_fk_veterinario     (ORA-02291 - FK veterinário ou especialidade)
--   3. WHEN OTHERS           (ID nulo - NOT NULL na PK)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    PRC_INSERT_VET_ESPECIALIDADE(
        p_id_especialidade_vet           => 1,
        p_tb_veterinario_id_veterinario  => 1,         -- Dr. Carlos
        p_tb_espcd_vet_id_espcd_vet      => 1          -- CARDIOLOGIA
    );
    DBMS_OUTPUT.PUT_LINE('[OK] PRC_INSERT_VET_ESPECIALIDADE - caminho feliz');
END;
/

-- [ERRO 1] ID de vínculo duplicado (PK)
BEGIN
    PRC_INSERT_VET_ESPECIALIDADE(
        p_id_especialidade_vet           => 1,         -- ID já existe
        p_tb_veterinario_id_veterinario  => 1,
        p_tb_espcd_vet_id_espcd_vet      => 2
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_VET_ESPECIALIDADE - pk duplicada: ' || SQLERRM);
END;
/

-- [ERRO 2] FK de veterinário inexistente
BEGIN
    PRC_INSERT_VET_ESPECIALIDADE(
        p_id_especialidade_vet           => 2,
        p_tb_veterinario_id_veterinario  => 9999,      -- veterinário inexistente
        p_tb_espcd_vet_id_espcd_vet      => 1
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_VET_ESPECIALIDADE - fk vet invalida: ' || SQLERRM);
END;
/

-- [ERRO 3] WHEN OTHERS - ID nulo (NOT NULL na PK)
BEGIN
    PRC_INSERT_VET_ESPECIALIDADE(
        p_id_especialidade_vet           => NULL,      -- NOT NULL violado
        p_tb_veterinario_id_veterinario  => 1,
        p_tb_espcd_vet_id_espcd_vet      => 1
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_VET_ESPECIALIDADE - OTHERS id nulo: ' || SQLERRM);
END;
/


-- ============================================================
-- TB_VETERINARIO_ESPECIE | PRC_INSERT_VET_ESPECIE
-- Exceções:
--   1. ex_vinculo_duplicado  (ORA-00001 - PK duplicada)
--   2. ex_fk_invalida        (ORA-02291 - FK espécie inexistente)
--   3. WHEN OTHERS           (FK veterinário nula - NOT NULL)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    PRC_INSERT_VET_ESPECIE(
        p_id_veterinario_especie         => 1,
        p_tb_veterinario_id_veterinario  => 1,         -- Dr. Carlos
        p_tb_especie_id_especie          => 1          -- CAO
    );
    DBMS_OUTPUT.PUT_LINE('[OK] PRC_INSERT_VET_ESPECIE - caminho feliz');
END;
/

-- [ERRO 1] ID de vínculo duplicado (PK)
BEGIN
    PRC_INSERT_VET_ESPECIE(
        p_id_veterinario_especie         => 1,         -- ID já existe
        p_tb_veterinario_id_veterinario  => 1,
        p_tb_especie_id_especie          => 2
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_VET_ESPECIE - pk duplicada: ' || SQLERRM);
END;
/

-- [ERRO 2] FK de espécie inexistente
BEGIN
    PRC_INSERT_VET_ESPECIE(
        p_id_veterinario_especie         => 2,
        p_tb_veterinario_id_veterinario  => 1,
        p_tb_especie_id_especie          => 7777       -- espécie inexistente
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_VET_ESPECIE - fk especie invalida: ' || SQLERRM);
END;
/

-- [ERRO 3] WHEN OTHERS - FK de veterinário nula
BEGIN
    PRC_INSERT_VET_ESPECIE(
        p_id_veterinario_especie         => 3,
        p_tb_veterinario_id_veterinario  => NULL,      -- NOT NULL violado
        p_tb_especie_id_especie          => 1
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_VET_ESPECIE - OTHERS fk nula: ' || SQLERRM);
END;
/


-- ============================================================
-- TB_ANIMAL | PRC_INSERT_ANIMAL
-- Exceções:
--   1. ex_sexo_invalido  (ORA-02290 - CHECK SX_ANIMAL)
--   2. ex_fk_invalida    (ORA-02291 - FK tutor ou espécie)
--   3. WHEN OTHERS       (peso excedendo precisão NUMBER(5,2))
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    PRC_INSERT_ANIMAL(
        p_id_animal             => 1,
        p_nm_animal             => 'Rex',
        p_rc_animal             => 'Labrador',
        p_sx_animal             => 'M',
        p_dt_nasc_animal        => TO_DATE('10/03/2020', 'DD/MM/YYYY'),
        p_nr_peso_animal        => 28.5,
        p_tb_tutor_id_tutor     => 1,
        p_tb_especie_id_especie => 1
    );
    DBMS_OUTPUT.PUT_LINE('[OK] PRC_INSERT_ANIMAL - caminho feliz');
END;
/

-- [ERRO 1] Sexo fora do CHECK ('F' ou 'M')
BEGIN
    PRC_INSERT_ANIMAL(
        p_id_animal             => 2,
        p_nm_animal             => 'Miau',
        p_rc_animal             => 'Siamês',
        p_sx_animal             => 'X',                -- valor inválido
        p_dt_nasc_animal        => TO_DATE('05/06/2021', 'DD/MM/YYYY'),
        p_nr_peso_animal        => 4.2,
        p_tb_tutor_id_tutor     => 1,
        p_tb_especie_id_especie => 2
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_ANIMAL - sexo invalido: ' || SQLERRM);
END;
/

-- [ERRO 2] FK de tutor inexistente
BEGIN
    PRC_INSERT_ANIMAL(
        p_id_animal             => 3,
        p_nm_animal             => 'Bolinha',
        p_rc_animal             => 'Poodle',
        p_sx_animal             => 'F',
        p_dt_nasc_animal        => TO_DATE('01/01/2022', 'DD/MM/YYYY'),
        p_nr_peso_animal        => 3.8,
        p_tb_tutor_id_tutor     => 5555,               -- tutor inexistente
        p_tb_especie_id_especie => 1
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_ANIMAL - fk tutor invalida: ' || SQLERRM);
END;
/

-- [ERRO 3] WHEN OTHERS - peso excede precisão NUMBER(5,2) - max 999.99
BEGIN
    PRC_INSERT_ANIMAL(
        p_id_animal             => 4,
        p_nm_animal             => 'Thor',
        p_rc_animal             => 'Pastor Alemão',
        p_sx_animal             => 'M',
        p_dt_nasc_animal        => TO_DATE('20/07/2019', 'DD/MM/YYYY'),
        p_nr_peso_animal        => 99999.99,           -- excede NUMBER(5,2)
        p_tb_tutor_id_tutor     => 1,
        p_tb_especie_id_especie => 1
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_ANIMAL - OTHERS peso invalido: ' || SQLERRM);
END;
/


-- ============================================================
-- TB_CONSULTA | PRC_INSERT_CONSULTA
-- Exceções:
--   1. ex_status_invalido  (ORA-02290 - CHECK ST_CONSULTA)
--   2. ex_fk_invalida      (ORA-02291 - FK animal inexistente)
--   3. WHEN OTHERS         (valor <= 0 - RAISE_APPLICATION_ERROR interno)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    PRC_INSERT_CONSULTA(
        p_id_consulta                   => 1,
        p_dt_hr_consulta                => TO_DATE('14/05/2026 09:00', 'DD/MM/YYYY HH24:MI'),
        p_st_consulta                   => 'AGENDADA',
        p_vl_consulta                   => 180.00,
        p_obs_consulta                  => 'Consulta de rotina anual',
        p_tb_veterinario_id_veterinario => 1,
        p_tb_animal_id_animal           => 1
    );
    DBMS_OUTPUT.PUT_LINE('[OK] PRC_INSERT_CONSULTA - caminho feliz');
END;
/

-- [ERRO 1] Status fora do CHECK
BEGIN
    PRC_INSERT_CONSULTA(
        p_id_consulta                   => 2,
        p_dt_hr_consulta                => SYSDATE,
        p_st_consulta                   => 'PENDENTE', -- não está no CHECK
        p_vl_consulta                   => 150.00,
        p_obs_consulta                  => NULL,
        p_tb_veterinario_id_veterinario => 1,
        p_tb_animal_id_animal           => 1
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_CONSULTA - status invalido: ' || SQLERRM);
END;
/

-- [ERRO 2] FK de animal inexistente
BEGIN
    PRC_INSERT_CONSULTA(
        p_id_consulta                   => 3,
        p_dt_hr_consulta                => SYSDATE,
        p_st_consulta                   => 'REALIZADA',
        p_vl_consulta                   => 200.00,
        p_obs_consulta                  => NULL,
        p_tb_veterinario_id_veterinario => 1,
        p_tb_animal_id_animal           => 4444        -- animal inexistente
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_CONSULTA - fk animal invalida: ' || SQLERRM);
END;
/

-- [ERRO 3] WHEN OTHERS - valor zero (regra de negócio interna da procedure)
BEGIN
    PRC_INSERT_CONSULTA(
        p_id_consulta                   => 4,
        p_dt_hr_consulta                => SYSDATE,
        p_st_consulta                   => 'AGENDADA',
        p_vl_consulta                   => 0,          -- valor <= 0 não permitido
        p_obs_consulta                  => NULL,
        p_tb_veterinario_id_veterinario => 1,
        p_tb_animal_id_animal           => 1
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_CONSULTA - OTHERS valor zero: ' || SQLERRM);
END;
/


-- ============================================================
-- TB_PRONTUARIO | PRC_INSERT_PRONTUARIO
-- Exceções:
--   1. ex_prontuario_duplicado  (ORA-00001 - UNIQUE INDEX por animal)
--   2. ex_fk_animal             (ORA-02291 - FK animal inexistente)
--   3. WHEN OTHERS              (data nula - NOT NULL)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    PRC_INSERT_PRONTUARIO(
        p_id_prontuario       => 1,
        p_dt_upd_pronturario  => SYSDATE,
        p_tb_animal_id_animal => 1
    );
    DBMS_OUTPUT.PUT_LINE('[OK] PRC_INSERT_PRONTUARIO - caminho feliz');
END;
/

-- [ERRO 1] Animal já possui prontuário (UNIQUE INDEX)
BEGIN
    PRC_INSERT_PRONTUARIO(
        p_id_prontuario       => 2,
        p_dt_upd_pronturario  => SYSDATE,
        p_tb_animal_id_animal => 1                     -- animal já tem prontuário
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_PRONTUARIO - prontuario duplicado: ' || SQLERRM);
END;
/

-- [ERRO 2] FK de animal inexistente
BEGIN
    PRC_INSERT_PRONTUARIO(
        p_id_prontuario       => 3,
        p_dt_upd_pronturario  => SYSDATE,
        p_tb_animal_id_animal => 3333                  -- animal inexistente
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_PRONTUARIO - fk animal invalida: ' || SQLERRM);
END;
/

-- [ERRO 3] WHEN OTHERS - data de atualização nula (NOT NULL)
BEGIN
    PRC_INSERT_PRONTUARIO(
        p_id_prontuario       => 4,
        p_dt_upd_pronturario  => NULL,                 -- NOT NULL violado
        p_tb_animal_id_animal => 1
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_PRONTUARIO - OTHERS data nula: ' || SQLERRM);
END;
/


-- ============================================================
-- TB_EVOLUCAO_CLINICA | PRC_INSERT_EVOLUCAO_CLINICA
-- Exceções:
--   1. ex_evolucao_duplicada  (ORA-00001 - UNIQUE INDEX por consulta)
--   2. ex_fk_invalida         (ORA-02291 - FK consulta inexistente)
--   3. WHEN OTHERS            (anotação vazia - RAISE_APPLICATION_ERROR interno)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    PRC_INSERT_EVOLUCAO_CLINICA(
        p_id_evolucao_clinica         => 1,
        p_ant_evolucao_clinica        => 'Animal apresentou bom estado geral. Vacinação em dia. Sem alterações clínicas.',
        p_tb_consulta_id_consulta     => 1,
        p_tb_prontuario_id_prontuario => 1
    );
    DBMS_OUTPUT.PUT_LINE('[OK] PRC_INSERT_EVOLUCAO_CLINICA - caminho feliz');
END;
/

-- [ERRO 1] Consulta já possui evolução clínica (UNIQUE INDEX)
BEGIN
    PRC_INSERT_EVOLUCAO_CLINICA(
        p_id_evolucao_clinica         => 2,
        p_ant_evolucao_clinica        => 'Segunda evolução para a mesma consulta.',
        p_tb_consulta_id_consulta     => 1,            -- consulta já tem evolução
        p_tb_prontuario_id_prontuario => 1
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_EVOLUCAO_CLINICA - duplicada: ' || SQLERRM);
END;
/

-- [ERRO 2] FK de consulta inexistente
BEGIN
    PRC_INSERT_EVOLUCAO_CLINICA(
        p_id_evolucao_clinica         => 3,
        p_ant_evolucao_clinica        => 'Anotação para consulta inexistente.',
        p_tb_consulta_id_consulta     => 2222,         -- consulta inexistente
        p_tb_prontuario_id_prontuario => 1
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_EVOLUCAO_CLINICA - fk consulta invalida: ' || SQLERRM);
END;
/

-- [ERRO 3] WHEN OTHERS - anotação com apenas espaços (validação interna)
BEGIN
    PRC_INSERT_EVOLUCAO_CLINICA(
        p_id_evolucao_clinica         => 4,
        p_ant_evolucao_clinica        => '   ',        -- TRIM resulta em NULL
        p_tb_consulta_id_consulta     => 1,
        p_tb_prontuario_id_prontuario => 1
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_EVOLUCAO_CLINICA - OTHERS anotacao vazia: ' || SQLERRM);
END;
/


-- ============================================================
-- TB_EXAME | PRC_INSERT_EXAME
-- Exceções:
--   1. ex_data_invalida  (data de resultado no futuro - validação interna)
--   2. ex_fk_invalida    (ORA-02291 - FK prontuário inexistente)
--   3. WHEN OTHERS       (nome do exame nulo - NOT NULL)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    PRC_INSERT_EXAME(
        p_id_exame                    => 1,
        p_nm_exame                    => 'Hemograma Completo',
        p_ds_res_exame                => 'Resultados dentro dos valores de referência para a espécie.',
        p_dt_res_exame                => TO_DATE('13/05/2026', 'DD/MM/YYYY'),
        p_st_exame                    => 'CONCLUIDO',
        p_tb_consulta_id_consulta     => 1,
        p_tb_prontuario_id_prontuario => 1,
        p_tb_animal_id_animal         => 1
    );
    DBMS_OUTPUT.PUT_LINE('[OK] PRC_INSERT_EXAME - caminho feliz');
END;
/

-- [ERRO 1] Data de resultado no futuro (validação interna da procedure)
BEGIN
    PRC_INSERT_EXAME(
        p_id_exame                    => 2,
        p_nm_exame                    => 'Raio-X Tórax',
        p_ds_res_exame                => 'Laudo pendente.',
        p_dt_res_exame                => TO_DATE('31/12/2030', 'DD/MM/YYYY'), -- data futura
        p_st_exame                    => 'AGUARDANDO',
        p_tb_consulta_id_consulta     => 1,
        p_tb_prontuario_id_prontuario => 1,
        p_tb_animal_id_animal         => 1
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_EXAME - data futura: ' || SQLERRM);
END;
/

-- [ERRO 2] FK de prontuário inexistente
BEGIN
    PRC_INSERT_EXAME(
        p_id_exame                    => 3,
        p_nm_exame                    => 'Ultrassom Abdominal',
        p_ds_res_exame                => 'Sem alterações.',
        p_dt_res_exame                => TO_DATE('10/05/2026', 'DD/MM/YYYY'),
        p_st_exame                    => 'CONCLUIDO',
        p_tb_consulta_id_consulta     => 1,
        p_tb_prontuario_id_prontuario => 6666,          -- prontuário inexistente
        p_tb_animal_id_animal         => 1
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_EXAME - fk prontuario invalida: ' || SQLERRM);
END;
/

-- [ERRO 3] WHEN OTHERS - nome do exame nulo (NOT NULL)
BEGIN
    PRC_INSERT_EXAME(
        p_id_exame                    => 4,
        p_nm_exame                    => NULL,          -- NOT NULL violado
        p_ds_res_exame                => 'Resultado qualquer.',
        p_dt_res_exame                => TO_DATE('01/05/2026', 'DD/MM/YYYY'),
        p_st_exame                    => 'CONCLUIDO',
        p_tb_consulta_id_consulta     => 1,
        p_tb_prontuario_id_prontuario => 1,
        p_tb_animal_id_animal         => 1
    );
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERRO ESPERADO] PRC_INSERT_EXAME - OTHERS nome nulo: ' || SQLERRM);
END;
/


-- ============================================================
-- VERIFICAÇÃO FINAL
-- ============================================================

-- Todos os erros registrados no log
SELECT
    ID,
    NOME_PROCEDURE,
    USUARIO_BANCO,
    TO_CHAR(DATA_OCORRENCIA, 'DD/MM/YYYY HH24:MI:SS') AS DATA_OCORRENCIA,
    CODIGO_ERRO,
    MENSAGEM_ERRO
FROM LOG_ERRO
ORDER BY ID;

-- Contagem de erros por procedure (deve haver 3 por tabela = 36 total)
SELECT NOME_PROCEDURE, COUNT(*) AS QTD_ERROS
FROM LOG_ERRO
GROUP BY NOME_PROCEDURE
ORDER BY NOME_PROCEDURE;

-- ============================================================
-- RESUMO DO SCRIPT
-- 12 tabelas x 4 testes = 48 blocos no total
--   12 x caminho feliz
--   12 x exceção personalizada 1
--   12 x exceção personalizada 2
--   12 x WHEN OTHERS
-- Erros esperados no LOG_ERRO: 36 registros (3 por tabela)
-- ============================================================
