#!/usr/bin/env bash
# Gera migrations/V10__pacotes_plsql_auditoria.sql a partir de scripts/01..05.
# A fonte da verdade sao os scripts; a migration e derivada. Depois de gerar,
# copie o arquivo para mvc-vetly-java/src/main/resources/db/migration/ (mesmo nome:
# o Flyway compara checksum, entao as duas copias precisam ser identicas).
#
#   ./gerar-migration.sh [pasta-destino]      (padrao: ../migrations)
set -euo pipefail
cd "$(dirname "$0")"
destino="${1:-../migrations}"
saida="$destino/V10__pacotes_plsql_auditoria.sql"

{
  cat <<'CABECALHO'
-- V10: pacotes PL/SQL, trilha de auditoria e trigger (Sprint 4 - Banco de Dados)
--
-- Cria PKG_VETLY_LOG, PKG_VETLY_VALIDACAO, PKG_VETLY_JSON e PKG_VETLY_RELATORIO,
-- a tabela TB_AUDITORIA e a trigger TRG_AUD_CONSULTA. O mvc-vetly-java consome
-- PKG_VETLY_RELATORIO; os demais servem a validacao, a exportacao para MongoDB
-- e a auditoria. Tudo e entregue por esta migration: qualquer ambiente que rode
-- o Flyway recebe os objetos, sem passo manual.
--
-- Fonte: vetly-database/vetly-sprint-4/scripts/01..05 (gerado por gerar-migration.sh).
-- NAO EDITE depois de aplicada: o checksum do Flyway cobre o arquivo inteiro.
CABECALHO
  for f in 01_pkg_vetly_log 02_pkg_vetly_validacao 03_pkg_vetly_json 04_pkg_vetly_relatorio 05_trigger_auditoria; do
    printf '\n-- ---------------------------------------------------------------- %s\n' "$f"
    cat "scripts/$f.sql"
  done
} > "$saida"

echo "gerado: $saida"
