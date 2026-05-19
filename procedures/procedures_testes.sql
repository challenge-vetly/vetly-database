-- ============================================================
-- TESTES DAS PROCEDURES DE CARGA
-- Cada bloco testa: caminho feliz + validacao de excecao
-- ============================================================


-- ============================================================
-- TESTE 1: SP_INS_USUARIO
-- ============================================================

-- [CAMINHO FELIZ] Insere usuario valido
BEGIN
    SP_INS_USUARIO(
        p_id_usuario        => 1,
        p_em_usuario        => 'joao.silva@email.com',
        p_rl_usuario        => 'TUTOR',
        p_fl_atv_usuario    => '1',
        p_sen_hash_usuario  => 'hash_senha_123'
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_USUARIO] CAMINHO FELIZ: OK');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_USUARIO] CAMINHO FELIZ FALHOU: ' || SQLERRM);
END;
/

-- [EXCECAO] DUP_VAL_ON_INDEX - tenta inserir mesmo ID
BEGIN
    SP_INS_USUARIO(
        p_id_usuario        => 1,
        p_em_usuario        => 'outro@email.com',
        p_rl_usuario        => 'ADMIN',
        p_fl_atv_usuario    => '1',
        p_sen_hash_usuario  => 'hash_456'
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_USUARIO] EXCECAO: NAO DISPAROU (ERRO NO TESTE)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_USUARIO] EXCECAO DUP_VAL_ON_INDEX: OK - ' || SQLERRM);
END;
/


-- ============================================================
-- TESTE 2: SP_INS_PESSOA
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    SP_INS_PESSOA(
        p_id_pessoa     => 1,
        p_nm_pessoa     => 'Joao da Silva',
        p_cpf_pessoa    => '12345678901',
        p_tel_pessoa    => '11999990001'
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_PESSOA] CAMINHO FELIZ: OK');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_PESSOA] CAMINHO FELIZ FALHOU: ' || SQLERRM);
END;
/

-- [EXCECAO] DUP_VAL_ON_INDEX - mesmo CPF e telefone
BEGIN
    SP_INS_PESSOA(
        p_id_pessoa     => 99,
        p_nm_pessoa     => 'Outro Nome',
        p_cpf_pessoa    => '12345678901',
        p_tel_pessoa    => '11999990001'
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_PESSOA] EXCECAO: NAO DISPAROU (ERRO NO TESTE)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_PESSOA] EXCECAO DUP_VAL_ON_INDEX: OK - ' || SQLERRM);
END;
/


-- ============================================================
-- TESTE 3: SP_INS_ESPECIE
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    SP_INS_ESPECIE(
        p_id_especie => 1,
        p_nm_especie => 'CAO'
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_ESPECIE] CAMINHO FELIZ: OK');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_ESPECIE] CAMINHO FELIZ FALHOU: ' || SQLERRM);
END;
/

-- [EXCECAO] CHECK CONSTRAINT - especie fora do dominio permitido
BEGIN
    SP_INS_ESPECIE(
        p_id_especie => 99,
        p_nm_especie => 'DRAGAO'
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_ESPECIE] EXCECAO: NAO DISPAROU (ERRO NO TESTE)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_ESPECIE] EXCECAO CHECK CONSTRAINT: OK - ' || SQLERRM);
END;
/


-- ============================================================
-- TESTE 4: SP_INS_ESPECIALIDADE_VET
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    SP_INS_ESPECIALIDADE_VET(
        p_id_especialidade_vet => 1,
        p_nm_especialidade     => 'CARDIOLOGIA',
        p_ds_especialidade     => 'Especialidade voltada ao coracao e sistema cardiovascular'
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_ESPECIALIDADE_VET] CAMINHO FELIZ: OK');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_ESPECIALIDADE_VET] CAMINHO FELIZ FALHOU: ' || SQLERRM);
END;
/

-- [EXCECAO] CHECK CONSTRAINT - especialidade fora do dominio
BEGIN
    SP_INS_ESPECIALIDADE_VET(
        p_id_especialidade_vet => 99,
        p_nm_especialidade     => 'CULINARIA',
        p_ds_especialidade     => 'Nao existe no CRMV'
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_ESPECIALIDADE_VET] EXCECAO: NAO DISPAROU (ERRO NO TESTE)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_ESPECIALIDADE_VET] EXCECAO CHECK CONSTRAINT: OK - ' || SQLERRM);
END;
/


-- ============================================================
-- TESTE 5: SP_INS_TUTOR
-- (depende de TB_USUARIO id=1 e TB_PESSOA id=1 ja inseridos)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    SP_INS_TUTOR(
        p_id_tutor              => 1,
        p_tb_usuario_id_usuario => 1,
        p_tb_pessoa_id_pessoa   => 1
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_TUTOR] CAMINHO FELIZ: OK');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_TUTOR] CAMINHO FELIZ FALHOU: ' || SQLERRM);
END;
/

-- [EXCECAO] FK VIOLATION - usuario inexistente
BEGIN
    SP_INS_TUTOR(
        p_id_tutor              => 99,
        p_tb_usuario_id_usuario => 9999,
        p_tb_pessoa_id_pessoa   => 1
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_TUTOR] EXCECAO: NAO DISPAROU (ERRO NO TESTE)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_TUTOR] EXCECAO FK VIOLATION: OK - ' || SQLERRM);
END;
/


-- ============================================================
-- TESTE 6: SP_INS_VETERINARIO
-- (depende de novo usuario e pessoa - ids 2)
-- ============================================================

-- Pre-requisito: inserir usuario e pessoa para o veterinario
BEGIN
    SP_INS_USUARIO(
        p_id_usuario        => 2,
        p_em_usuario        => 'dra.ana@clinica.com',
        p_rl_usuario        => 'VETERINARIO',
        p_fl_atv_usuario    => '1',
        p_sen_hash_usuario  => 'hash_vet_ana'
    );
    SP_INS_PESSOA(
        p_id_pessoa     => 2,
        p_nm_pessoa     => 'Ana Paula Souza',
        p_cpf_pessoa    => '98765432100',
        p_tel_pessoa    => '11988880002'
    );
    DBMS_OUTPUT.PUT_LINE('[PRE-REQUISITO VET] Usuarios e Pessoa inseridos: OK');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[PRE-REQUISITO VET] FALHOU: ' || SQLERRM);
END;
/

-- [CAMINHO FELIZ]
BEGIN
    SP_INS_VETERINARIO(
        p_id_veterinario        => 1,
        p_crmv_veterinario      => 'CRMV-SP-12345',
        p_tb_usuario_id_usuario => 2,
        p_tb_pessoa_id_pessoa   => 2
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_VETERINARIO] CAMINHO FELIZ: OK');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_VETERINARIO] CAMINHO FELIZ FALHOU: ' || SQLERRM);
END;
/

-- [EXCECAO] DUP_VAL_ON_INDEX - mesmo CRMV
BEGIN
    SP_INS_VETERINARIO(
        p_id_veterinario        => 98,
        p_crmv_veterinario      => 'CRMV-SP-12345',
        p_tb_usuario_id_usuario => 2,
        p_tb_pessoa_id_pessoa   => 2
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_VETERINARIO] EXCECAO: NAO DISPAROU (ERRO NO TESTE)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_VETERINARIO] EXCECAO DUP_VAL_ON_INDEX: OK - ' || SQLERRM);
END;
/


-- ============================================================
-- TESTE 7: SP_INS_VET_ESPECIALIDADE
-- (depende de veterinario id=1 e especialidade id=1)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    SP_INS_VET_ESPECIALIDADE(
        p_id_especialidade_veterinario  => 1,
        p_tb_veterinario_id_veterinario => 1,
        p_tb_espcd_vet_id_espcd_vet     => 1
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_VET_ESPECIALIDADE] CAMINHO FELIZ: OK');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_VET_ESPECIALIDADE] CAMINHO FELIZ FALHOU: ' || SQLERRM);
END;
/

-- [EXCECAO] DUP_VAL_ON_INDEX - mesma combinacao veterinario+especialidade
BEGIN
    SP_INS_VET_ESPECIALIDADE(
        p_id_especialidade_veterinario  => 99,
        p_tb_veterinario_id_veterinario => 1,
        p_tb_espcd_vet_id_espcd_vet     => 1
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_VET_ESPECIALIDADE] EXCECAO: NAO DISPAROU (ERRO NO TESTE)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_VET_ESPECIALIDADE] EXCECAO DUP_VAL_ON_INDEX: OK - ' || SQLERRM);
END;
/


-- ============================================================
-- TESTE 8: SP_INS_VET_ESPECIE
-- (depende de veterinario id=1 e especie id=1)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    SP_INS_VET_ESPECIE(
        p_id_veterinario_especie        => 1,
        p_tb_veterinario_id_veterinario => 1,
        p_tb_especie_id_especie         => 1
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_VET_ESPECIE] CAMINHO FELIZ: OK');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_VET_ESPECIE] CAMINHO FELIZ FALHOU: ' || SQLERRM);
END;
/

-- [EXCECAO] DUP_VAL_ON_INDEX - mesma combinacao veterinario+especie
BEGIN
    SP_INS_VET_ESPECIE(
        p_id_veterinario_especie        => 99,
        p_tb_veterinario_id_veterinario => 1,
        p_tb_especie_id_especie         => 1
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_VET_ESPECIE] EXCECAO: NAO DISPAROU (ERRO NO TESTE)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_VET_ESPECIE] EXCECAO DUP_VAL_ON_INDEX: OK - ' || SQLERRM);
END;
/


-- ============================================================
-- TESTE 9: SP_INS_ANIMAL
-- (depende de tutor id=1 e especie id=1)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    SP_INS_ANIMAL(
        p_id_animal             => 1,
        p_nm_animal             => 'Rex',
        p_rc_animal             => 'Labrador',
        p_sx_animal             => 'M',
        p_dt_nasc_animal        => TO_DATE('2020-03-15', 'YYYY-MM-DD'),
        p_nr_peso_animal        => 28.5,
        p_tb_tutor_id_tutor     => 1,
        p_tb_especie_id_especie => 1
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_ANIMAL] CAMINHO FELIZ: OK');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_ANIMAL] CAMINHO FELIZ FALHOU: ' || SQLERRM);
END;
/

-- [EXCECAO] CHECK CONSTRAINT - sexo invalido
BEGIN
    SP_INS_ANIMAL(
        p_id_animal             => 99,
        p_nm_animal             => 'Bolt',
        p_rc_animal             => 'Vira-lata',
        p_sx_animal             => 'X',
        p_dt_nasc_animal        => TO_DATE('2021-01-01', 'YYYY-MM-DD'),
        p_nr_peso_animal        => 10.0,
        p_tb_tutor_id_tutor     => 1,
        p_tb_especie_id_especie => 1
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_ANIMAL] EXCECAO: NAO DISPAROU (ERRO NO TESTE)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_ANIMAL] EXCECAO CHECK CONSTRAINT (SX): OK - ' || SQLERRM);
END;
/


-- ============================================================
-- TESTE 10: SP_INS_PRONTUARIO
-- (depende de animal id=1)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    SP_INS_PRONTUARIO(
        p_id_prontuario       => 1,
        p_dt_upd_pronturario  => SYSDATE,
        p_tb_animal_id_animal => 1
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_PRONTUARIO] CAMINHO FELIZ: OK');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_PRONTUARIO] CAMINHO FELIZ FALHOU: ' || SQLERRM);
END;
/

-- [EXCECAO] DUP_VAL_ON_INDEX - mesmo animal (unique index)
BEGIN
    SP_INS_PRONTUARIO(
        p_id_prontuario       => 99,
        p_dt_upd_pronturario  => SYSDATE,
        p_tb_animal_id_animal => 1
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_PRONTUARIO] EXCECAO: NAO DISPAROU (ERRO NO TESTE)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_PRONTUARIO] EXCECAO DUP_VAL_ON_INDEX: OK - ' || SQLERRM);
END;
/


-- ============================================================
-- TESTE 11: SP_INS_CONSULTA
-- (depende de veterinario id=1 e animal id=1)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    SP_INS_CONSULTA(
        p_id_consulta                   => 1,
        p_dt_hr_consulta                => TO_DATE('2026-05-19 10:00', 'YYYY-MM-DD HH24:MI'),
        p_st_consulta                   => 'AGENDADA',
        p_vl_consulta                   => 150.00,
        p_obs_consulta                  => 'Consulta de rotina',
        p_tb_veterinario_id_veterinario => 1,
        p_tb_animal_id_animal           => 1
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_CONSULTA] CAMINHO FELIZ: OK');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_CONSULTA] CAMINHO FELIZ FALHOU: ' || SQLERRM);
END;
/

-- [EXCECAO] CHECK CONSTRAINT - status invalido
BEGIN
    SP_INS_CONSULTA(
        p_id_consulta                   => 99,
        p_dt_hr_consulta                => SYSDATE,
        p_st_consulta                   => 'PENDENTE',
        p_vl_consulta                   => 200.00,
        p_obs_consulta                  => NULL,
        p_tb_veterinario_id_veterinario => 1,
        p_tb_animal_id_animal           => 1
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_CONSULTA] EXCECAO: NAO DISPAROU (ERRO NO TESTE)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_CONSULTA] EXCECAO CHECK CONSTRAINT (ST): OK - ' || SQLERRM);
END;
/


-- ============================================================
-- TESTE 12: SP_INS_EVOLUCAO_CLINICA
-- (depende de consulta id=1)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    SP_INS_EVOLUCAO_CLINICA(
        p_id_evolucao_clinica     => 1,
        p_ant_evolucao_clinica    => 'Animal apresentou melhora. Retorno em 30 dias.',
        p_tb_consulta_id_consulta => 1
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_EVOLUCAO_CLINICA] CAMINHO FELIZ: OK');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_EVOLUCAO_CLINICA] CAMINHO FELIZ FALHOU: ' || SQLERRM);
END;
/

-- [EXCECAO] DUP_VAL_ON_INDEX - mesma consulta (unique index)
BEGIN
    SP_INS_EVOLUCAO_CLINICA(
        p_id_evolucao_clinica     => 99,
        p_ant_evolucao_clinica    => 'Outra anotacao para a mesma consulta.',
        p_tb_consulta_id_consulta => 1
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_EVOLUCAO_CLINICA] EXCECAO: NAO DISPAROU (ERRO NO TESTE)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_EVOLUCAO_CLINICA] EXCECAO DUP_VAL_ON_INDEX: OK - ' || SQLERRM);
END;
/


-- ============================================================
-- TESTE 13: SP_INS_SOLICITACAO_EXAME
-- (depende de consulta id=1)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    SP_INS_SOLICITACAO_EXAME(
        p_id_solicitacao_exame    => 1,
        p_obs_solicitacao         => 'Solicitar hemograma completo e bioquimico.',
        p_tb_consulta_id_consulta => 1
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_SOLICITACAO_EXAME] CAMINHO FELIZ: OK');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_SOLICITACAO_EXAME] CAMINHO FELIZ FALHOU: ' || SQLERRM);
END;
/

-- [EXCECAO] DUP_VAL_ON_INDEX - mesma consulta (unique index)
BEGIN
    SP_INS_SOLICITACAO_EXAME(
        p_id_solicitacao_exame    => 99,
        p_obs_solicitacao         => 'Segunda solicitacao para mesma consulta.',
        p_tb_consulta_id_consulta => 1
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_SOLICITACAO_EXAME] EXCECAO: NAO DISPAROU (ERRO NO TESTE)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_SOLICITACAO_EXAME] EXCECAO DUP_VAL_ON_INDEX: OK - ' || SQLERRM);
END;
/


-- ============================================================
-- TESTE 14: SP_INS_SOLICITACAO_EXAME_ITEM
-- (depende de solicitacao_exame id=1)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    SP_INS_SOLICITACAO_EXAME_ITEM(
        p_id_solicitacao_exame_item     => 1,
        p_nm_exame                      => 'Hemograma Completo',
        p_st_exame                      => 'SOLICITADO',
        p_dt_solc_exame                 => SYSDATE,
        p_dt_res_exame                  => NULL,
        p_ds_res_exame                  => NULL,
        p_dt_analise                    => NULL,
        p_dt_envio_resultado            => NULL,
        p_tb_solct_exame_id_solct_exame => 1
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_SOLICITACAO_EXAME_ITEM] CAMINHO FELIZ: OK');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_SOLICITACAO_EXAME_ITEM] CAMINHO FELIZ FALHOU: ' || SQLERRM);
END;
/

-- [EXCECAO] CHECK CONSTRAINT - status invalido
BEGIN
    SP_INS_SOLICITACAO_EXAME_ITEM(
        p_id_solicitacao_exame_item     => 99,
        p_nm_exame                      => 'Bioquimico',
        p_st_exame                      => 'EM_ANDAMENTO',
        p_dt_solc_exame                 => SYSDATE,
        p_dt_res_exame                  => NULL,
        p_ds_res_exame                  => NULL,
        p_dt_analise                    => NULL,
        p_dt_envio_resultado            => NULL,
        p_tb_solct_exame_id_solct_exame => 1
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_SOLICITACAO_EXAME_ITEM] EXCECAO: NAO DISPAROU (ERRO NO TESTE)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_SOLICITACAO_EXAME_ITEM] EXCECAO CHECK CONSTRAINT (ST): OK - ' || SQLERRM);
END;
/


-- ============================================================
-- TESTE 15: SP_INS_ANEXO_EXAME
-- (depende de solicitacao_exame_item id=1)
-- ============================================================

-- [CAMINHO FELIZ]
BEGIN
    SP_INS_ANEXO_EXAME(
        p_id_anexo_exame                => 1,
        p_url_arquivo_anexo             => 'https://storage.clinica.com/exames/hemograma_rex_20260519.pdf',
        p_mime_type_anexo               => 'application/pdf',
        p_dt_upload_anexo               => SYSDATE,
        p_tb_slc_ex_item_id_slc_ex_item => 1
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_ANEXO_EXAME] CAMINHO FELIZ: OK');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_ANEXO_EXAME] CAMINHO FELIZ FALHOU: ' || SQLERRM);
END;
/

-- [EXCECAO] FK VIOLATION - item de exame inexistente
BEGIN
    SP_INS_ANEXO_EXAME(
        p_id_anexo_exame                => 99,
        p_url_arquivo_anexo             => 'https://storage.clinica.com/exames/resultado_inexistente.pdf',
        p_mime_type_anexo               => 'application/pdf',
        p_dt_upload_anexo               => SYSDATE,
        p_tb_slc_ex_item_id_slc_ex_item => 9999
    );
    DBMS_OUTPUT.PUT_LINE('[SP_INS_ANEXO_EXAME] EXCECAO: NAO DISPAROU (ERRO NO TESTE)');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[SP_INS_ANEXO_EXAME] EXCECAO FK VIOLATION: OK - ' || SQLERRM);
END;
/


-- ============================================================
-- VERIFICACAO FINAL: registros gravados na tabela de log
-- ============================================================
SELECT
    ID_LOG,
    NM_PROCEDURE,
    NM_USUARIO,
    DT_OCORRENCIA,
    CD_ERRO,
    DS_MENSAGEM
FROM TB_LOG_ERRO
ORDER BY ID_LOG;
