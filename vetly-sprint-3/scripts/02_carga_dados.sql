-- ============================================================================
-- SPRINT 3 - MASTERING RELATIONAL AND NON-RELATIONAL DATABASE
-- CARGA DE DADOS
--
-- Popula as tabelas criadas em 01_ddl_estrutura.sql com registros validos e
-- suficientes para exercitar Procedimento 1 (JOIN -> JSON), Procedimento 2
-- (fatos/subtotal/total) e o Trigger de auditoria (TB_CONSULTA).
--
-- Cada tabela usada pelo Procedimento 1 (TB_USUARIO, TB_PESSOA, TB_ESPECIE,
-- TB_TUTOR, TB_ANIMAL) recebe pelo menos 5 registros validos.
-- TB_CONSULTA (tabela de fatos do Procedimento 2) recebe 6 linhas detalhadas,
-- cruzando 2 veterinarios (categoria 1) x 3 status distintos (categoria 2),
-- para permitir combinacao completa + subtotal por veterinario + total geral.
-- ============================================================================

-- ------------------------------------------------------------
-- TB_USUARIO (5 tutores + 2 veterinarios = 7 registros)
-- ------------------------------------------------------------
INSERT INTO TB_USUARIO (ID_USUARIO, EM_USUARIO, RL_USUARIO, FL_ATV_USUARIO, SEN_HASH_USUARIO) VALUES ('USU-T1', 'joao.silva@vetly.com',    'TUTOR',       '1', 'hash_t1');
INSERT INTO TB_USUARIO (ID_USUARIO, EM_USUARIO, RL_USUARIO, FL_ATV_USUARIO, SEN_HASH_USUARIO) VALUES ('USU-T2', 'ana.souza@vetly.com',     'TUTOR',       '1', 'hash_t2');
INSERT INTO TB_USUARIO (ID_USUARIO, EM_USUARIO, RL_USUARIO, FL_ATV_USUARIO, SEN_HASH_USUARIO) VALUES ('USU-T3', 'carlos.pereira@vetly.com','TUTOR',       '1', 'hash_t3');
INSERT INTO TB_USUARIO (ID_USUARIO, EM_USUARIO, RL_USUARIO, FL_ATV_USUARIO, SEN_HASH_USUARIO) VALUES ('USU-T4', 'mariana.lima@vetly.com',  'TUTOR',       '1', 'hash_t4');
INSERT INTO TB_USUARIO (ID_USUARIO, EM_USUARIO, RL_USUARIO, FL_ATV_USUARIO, SEN_HASH_USUARIO) VALUES ('USU-T5', 'pedro.rocha@vetly.com',   'TUTOR',       '1', 'hash_t5');
INSERT INTO TB_USUARIO (ID_USUARIO, EM_USUARIO, RL_USUARIO, FL_ATV_USUARIO, SEN_HASH_USUARIO) VALUES ('USU-V1', 'dra.fernanda@vetly.com',  'VETERINARIO', '1', 'hash_v1');
INSERT INTO TB_USUARIO (ID_USUARIO, EM_USUARIO, RL_USUARIO, FL_ATV_USUARIO, SEN_HASH_USUARIO) VALUES ('USU-V2', 'dr.ricardo@vetly.com',    'VETERINARIO', '1', 'hash_v2');

-- ------------------------------------------------------------
-- TB_PESSOA (5 tutores + 2 veterinarios = 7 registros)
-- ------------------------------------------------------------
INSERT INTO TB_PESSOA (ID_PESSOA, NM_PESSOA, CPF_PESSOA, TEL_PESSOA) VALUES ('PES-T1', 'Joao Silva',      '11144477735', '11999990001');
INSERT INTO TB_PESSOA (ID_PESSOA, NM_PESSOA, CPF_PESSOA, TEL_PESSOA) VALUES ('PES-T2', 'Ana Souza',       '52998224725', '11999990002');
INSERT INTO TB_PESSOA (ID_PESSOA, NM_PESSOA, CPF_PESSOA, TEL_PESSOA) VALUES ('PES-T3', 'Carlos Pereira',  '15350946056', '11999990003');
INSERT INTO TB_PESSOA (ID_PESSOA, NM_PESSOA, CPF_PESSOA, TEL_PESSOA) VALUES ('PES-T4', 'Mariana Lima',    '90178903096', '11999990004');
INSERT INTO TB_PESSOA (ID_PESSOA, NM_PESSOA, CPF_PESSOA, TEL_PESSOA) VALUES ('PES-T5', 'Pedro Rocha',     '48693753027', '11999990005');
INSERT INTO TB_PESSOA (ID_PESSOA, NM_PESSOA, CPF_PESSOA, TEL_PESSOA) VALUES ('PES-V1', 'Fernanda Alves',  '39053344705', '11988880001');
INSERT INTO TB_PESSOA (ID_PESSOA, NM_PESSOA, CPF_PESSOA, TEL_PESSOA) VALUES ('PES-V2', 'Ricardo Nunes',   '96382913060', '11988880002');

-- ------------------------------------------------------------
-- TB_ESPECIE (5 especies dentro do dominio permitido pelo CK_ESPECIE)
-- ------------------------------------------------------------
INSERT INTO TB_ESPECIE (ID_ESPECIE, NM_ESPECIE) VALUES ('ESP-CAO',     'CAO');
INSERT INTO TB_ESPECIE (ID_ESPECIE, NM_ESPECIE) VALUES ('ESP-GATO',    'GATO');
INSERT INTO TB_ESPECIE (ID_ESPECIE, NM_ESPECIE) VALUES ('ESP-AVE',     'AVE');
INSERT INTO TB_ESPECIE (ID_ESPECIE, NM_ESPECIE) VALUES ('ESP-EQUIDEO', 'EQUIDEO');
INSERT INTO TB_ESPECIE (ID_ESPECIE, NM_ESPECIE) VALUES ('ESP-REPTIL',  'REPTIL');

-- ------------------------------------------------------------
-- TB_TUTOR (5 registros, um por usuario/pessoa tutor)
-- ------------------------------------------------------------
INSERT INTO TB_TUTOR (ID_TUTOR, TB_USUARIO_ID_USUARIO, TB_PESSOA_ID_PESSOA) VALUES ('TUT-1', 'USU-T1', 'PES-T1');
INSERT INTO TB_TUTOR (ID_TUTOR, TB_USUARIO_ID_USUARIO, TB_PESSOA_ID_PESSOA) VALUES ('TUT-2', 'USU-T2', 'PES-T2');
INSERT INTO TB_TUTOR (ID_TUTOR, TB_USUARIO_ID_USUARIO, TB_PESSOA_ID_PESSOA) VALUES ('TUT-3', 'USU-T3', 'PES-T3');
INSERT INTO TB_TUTOR (ID_TUTOR, TB_USUARIO_ID_USUARIO, TB_PESSOA_ID_PESSOA) VALUES ('TUT-4', 'USU-T4', 'PES-T4');
INSERT INTO TB_TUTOR (ID_TUTOR, TB_USUARIO_ID_USUARIO, TB_PESSOA_ID_PESSOA) VALUES ('TUT-5', 'USU-T5', 'PES-T5');

-- ------------------------------------------------------------
-- TB_VETERINARIO (2 registros -- categoria 1 do Procedimento 2)
-- ------------------------------------------------------------
INSERT INTO TB_VETERINARIO (ID_VETERINARIO, CRMV_VETERINARIO, TB_USUARIO_ID_USUARIO, TB_PESSOA_ID_PESSOA) VALUES ('VET-1', 'CRMV-SP-10001', 'USU-V1', 'PES-V1');
INSERT INTO TB_VETERINARIO (ID_VETERINARIO, CRMV_VETERINARIO, TB_USUARIO_ID_USUARIO, TB_PESSOA_ID_PESSOA) VALUES ('VET-2', 'CRMV-SP-10002', 'USU-V2', 'PES-V2');

-- ------------------------------------------------------------
-- TB_ANIMAL (5 registros, um por tutor, especies variadas)
-- ------------------------------------------------------------
INSERT INTO TB_ANIMAL (ID_ANIMAL, NM_ANIMAL, RC_ANIMAL, SX_ANIMAL, DT_NASC_ANIMAL, NR_PESO_ANIMAL, TB_TUTOR_ID_TUTOR, TB_ESPECIE_ID_ESPECIE) VALUES ('ANI-1', 'Rex',    'Labrador',     'M', DATE '2020-03-15', 28.5, 'TUT-1', 'ESP-CAO');
INSERT INTO TB_ANIMAL (ID_ANIMAL, NM_ANIMAL, RC_ANIMAL, SX_ANIMAL, DT_NASC_ANIMAL, NR_PESO_ANIMAL, TB_TUTOR_ID_TUTOR, TB_ESPECIE_ID_ESPECIE) VALUES ('ANI-2', 'Mimi',   'Siames',       'F', DATE '2021-07-02', 4.2,  'TUT-2', 'ESP-GATO');
INSERT INTO TB_ANIMAL (ID_ANIMAL, NM_ANIMAL, RC_ANIMAL, SX_ANIMAL, DT_NASC_ANIMAL, NR_PESO_ANIMAL, TB_TUTOR_ID_TUTOR, TB_ESPECIE_ID_ESPECIE) VALUES ('ANI-3', 'Piu',    'Calopsita',    'M', DATE '2022-01-10', 0.12, 'TUT-3', 'ESP-AVE');
INSERT INTO TB_ANIMAL (ID_ANIMAL, NM_ANIMAL, RC_ANIMAL, SX_ANIMAL, DT_NASC_ANIMAL, NR_PESO_ANIMAL, TB_TUTOR_ID_TUTOR, TB_ESPECIE_ID_ESPECIE) VALUES ('ANI-4', 'Trovao', 'Quarto de Milha','M', DATE '2018-05-20', 410.0,'TUT-4', 'ESP-EQUIDEO');
INSERT INTO TB_ANIMAL (ID_ANIMAL, NM_ANIMAL, RC_ANIMAL, SX_ANIMAL, DT_NASC_ANIMAL, NR_PESO_ANIMAL, TB_TUTOR_ID_TUTOR, TB_ESPECIE_ID_ESPECIE) VALUES ('ANI-5', 'Draco',  'Iguana Verde', 'M', DATE '2019-09-08', 3.8,  'TUT-5', 'ESP-REPTIL');

-- ------------------------------------------------------------
-- TB_CONSULTA (6 linhas de fato: 2 veterinarios x status distintos)
-- Ordenacao por VET (categoria 1) e depois por STATUS (categoria 2), como
-- exigido pela hierarquia de exibicao do Procedimento 2.
-- ------------------------------------------------------------
INSERT INTO TB_CONSULTA (ID_CONSULTA, DT_HR_CONSULTA, ST_CONSULTA, VL_CONSULTA, OBS_CONSULTA, TB_VETERINARIO_ID_VETERINARIO, TB_ANIMAL_ID_ANIMAL) VALUES ('CONS-1', DATE '2026-08-01', 'REALIZADA', 150.00, 'Consulta de rotina',        'VET-1', 'ANI-1');
INSERT INTO TB_CONSULTA (ID_CONSULTA, DT_HR_CONSULTA, ST_CONSULTA, VL_CONSULTA, OBS_CONSULTA, TB_VETERINARIO_ID_VETERINARIO, TB_ANIMAL_ID_ANIMAL) VALUES ('CONS-2', DATE '2026-08-05', 'REALIZADA', 200.00, 'Retorno pos-cirurgico',     'VET-1', 'ANI-2');
INSERT INTO TB_CONSULTA (ID_CONSULTA, DT_HR_CONSULTA, ST_CONSULTA, VL_CONSULTA, OBS_CONSULTA, TB_VETERINARIO_ID_VETERINARIO, TB_ANIMAL_ID_ANIMAL) VALUES ('CONS-3', DATE '2026-08-10', 'AGENDADA',  120.00, 'Avaliacao clinica geral',   'VET-1', 'ANI-3');
INSERT INTO TB_CONSULTA (ID_CONSULTA, DT_HR_CONSULTA, ST_CONSULTA, VL_CONSULTA, OBS_CONSULTA, TB_VETERINARIO_ID_VETERINARIO, TB_ANIMAL_ID_ANIMAL) VALUES ('CONS-4', DATE '2026-08-12', 'CANCELADA',  80.00, 'Tutor remarcou',            'VET-1', 'ANI-4');
INSERT INTO TB_CONSULTA (ID_CONSULTA, DT_HR_CONSULTA, ST_CONSULTA, VL_CONSULTA, OBS_CONSULTA, TB_VETERINARIO_ID_VETERINARIO, TB_ANIMAL_ID_ANIMAL) VALUES ('CONS-5', DATE '2026-08-15', 'REALIZADA', 300.00, 'Cirurgia de pequeno porte', 'VET-2', 'ANI-5');
INSERT INTO TB_CONSULTA (ID_CONSULTA, DT_HR_CONSULTA, ST_CONSULTA, VL_CONSULTA, OBS_CONSULTA, TB_VETERINARIO_ID_VETERINARIO, TB_ANIMAL_ID_ANIMAL) VALUES ('CONS-6', DATE '2026-08-18', 'AGENDADA',   90.00, 'Vacinacao anual',           'VET-2', 'ANI-1');

COMMIT;
