# Migrations (Flyway) V1–V10

Cópia das migrations aplicadas pelo painel Java (`mvc-vetly-java/src/main/resources/db/migration/`).
O Flyway roda a partir do classpath do Java; este diretório é o espelho para que o repositório de
banco tenha o schema completo da Sprint 4 (`DDL.txt` consolida V1–V8).

- `V1`–`V8`: schema (refletido em `../DDL.txt`). `V9`: seed de `TB_ESPECIE`/`TB_ESPECIALIDADES_VET`.
- `V10`: pacotes PL/SQL + `TB_AUDITORIA` + trigger, **gerada** de `../scripts/01..05` por `../gerar-migration.sh`.

Nunca edite uma migration já aplicada (checksum do Flyway): crie a próxima versão.
