-- ============================================================================
-- SPRINT 3 - MASTERING RELATIONAL AND NON-RELATIONAL DATABASE
-- TRIGGER DE AUDITORIA (DML)
--
-- TB_AUDITORIA ja foi criada em 01_ddl_estrutura.sql com os campos exigidos:
-- nome do usuario, tipo da operacao, data/hora, valores anteriores (:OLD) e
-- valores novos (:NEW).
--
-- TRG_AUD_CONSULTA dispara AFTER INSERT OR UPDATE OR DELETE ON TB_CONSULTA
-- (a mesma tabela de fatos do Procedimento 2) e grava uma linha de auditoria
-- a cada operacao, com :OLD e :NEW formatados manualmente como pares
-- "coluna=valor" (sem usar nenhum recurso pronto de serializacao).
-- ============================================================================
CREATE OR REPLACE TRIGGER TRG_AUD_CONSULTA
AFTER INSERT OR UPDATE OR DELETE ON TB_CONSULTA
FOR EACH ROW
DECLARE
    v_tp_operacao   VARCHAR2(10);
    v_valores_old   VARCHAR2(4000);
    v_valores_new   VARCHAR2(4000);
BEGIN
    -- Bloco de tipo da operacao: as pseudo-funcoes INSERTING/UPDATING/DELETING
    -- identificam qual evento disparou a trigger nesta execucao
    IF INSERTING THEN
        v_tp_operacao := 'INSERT';
    ELSIF UPDATING THEN
        v_tp_operacao := 'UPDATE';
    ELSIF DELETING THEN
        v_tp_operacao := 'DELETE';
    END IF;

    -- Valores anteriores (:OLD) -- nao existem em INSERT
    IF NOT INSERTING THEN
        v_valores_old :=
            'ID_CONSULTA='    || :OLD.ID_CONSULTA    ||
            '|DT_HR_CONSULTA='|| TO_CHAR(:OLD.DT_HR_CONSULTA, 'DD/MM/YYYY HH24:MI') ||
            '|ST_CONSULTA='   || :OLD.ST_CONSULTA    ||
            '|VL_CONSULTA='   || TO_CHAR(:OLD.VL_CONSULTA, 'FM9999990.00') ||
            '|OBS_CONSULTA='  || :OLD.OBS_CONSULTA   ||
            '|VETERINARIO='   || :OLD.TB_VETERINARIO_ID_VETERINARIO ||
            '|ANIMAL='        || :OLD.TB_ANIMAL_ID_ANIMAL;
    END IF;

    -- Valores novos (:NEW) -- nao existem em DELETE
    IF NOT DELETING THEN
        v_valores_new :=
            'ID_CONSULTA='    || :NEW.ID_CONSULTA    ||
            '|DT_HR_CONSULTA='|| TO_CHAR(:NEW.DT_HR_CONSULTA, 'DD/MM/YYYY HH24:MI') ||
            '|ST_CONSULTA='   || :NEW.ST_CONSULTA    ||
            '|VL_CONSULTA='   || TO_CHAR(:NEW.VL_CONSULTA, 'FM9999990.00') ||
            '|OBS_CONSULTA='  || :NEW.OBS_CONSULTA   ||
            '|VETERINARIO='   || :NEW.TB_VETERINARIO_ID_VETERINARIO ||
            '|ANIMAL='        || :NEW.TB_ANIMAL_ID_ANIMAL;
    END IF;

    INSERT INTO TB_AUDITORIA (
        ID_AUDITORIA, NM_TABELA, NM_USUARIO, TP_OPERACAO, DT_HR_OPERACAO,
        DS_VALORES_ANTIGOS, DS_VALORES_NOVOS
    ) VALUES (
        SQ_AUDITORIA.NEXTVAL, 'TB_CONSULTA', USER, v_tp_operacao, SYSDATE,
        v_valores_old, v_valores_new
    );
EXCEPTION
    -- Uma trigger de auditoria nunca pode impedir a operacao de negocio que a
    -- disparou: qualquer falha ao gravar o log e registrada em TB_LOG_ERRO e
    -- engolida aqui, deixando o INSERT/UPDATE/DELETE original seguir seu curso.
    WHEN OTHERS THEN
        SP_REGISTRA_LOG('TRG_AUD_CONSULTA', SQLCODE, SQLERRM);
END TRG_AUD_CONSULTA;
/
