# Migrations (Flyway) — origem `mvc-vetly-java`

Copia de referência de `mvc-vetly-java/src/main/resources/db/migration/`, mantida aqui para
que `vetly-database` (procedures, cargas, DDL consolidado) evolua junto com o schema real
aplicado pela aplicação Java. **Não é a fonte de verdade nem é executada a partir daqui** —
o Flyway roda a partir do classpath de `mvc-vetly-java`; este diretório é só o espelho usado
para acompanhar o schema ao atualizar `DDL.txt` e as procedures de carga/teste deste repositório.

`V1`–`V8` já estão refletidas em `../DDL.txt` (mesmo conteúdo que as migrations equivalentes de
`vetly-java`, ver `project-context/docs/java-database-alignment.md`). `V9` é seed de dados
(`TB_ESPECIE`/`TB_ESPECIALIDADES_VET`) específico de `mvc-vetly-java` — não é DDL, por isso não
entra em `DDL.txt`, mas as procedures de carga deste repo (`../procedures/`) foram revisadas
para não colidir com esses seeds e para cobrir as colunas que `V2`–`V8` adicionaram.

Ao atualizar este espelho, reexecute a comparação com `mvc-vetly-java/src/main/resources/db/migration/`
e replique qualquer `ALTER`/`CREATE TABLE` novo em `../DDL.txt`.

## V10 — exceção à regra de espelho

`V10__pacotes_plsql_auditoria.sql` nasce **neste repositório**: é gerada por
`../vetly-sprint-4/gerar-migration.sh` a partir de `../vetly-sprint-4/scripts/01..05` (pacotes
`PKG_VETLY_*`, `TB_AUDITORIA` e `TRG_AUD_CONSULTA`) e então copiada, byte a byte, para
`mvc-vetly-java/src/main/resources/db/migration/`. Para alterar qualquer um desses objetos,
edite os scripts, regere e **crie uma V11** — nunca reedite uma migration já aplicada (o
checksum do Flyway cobre o arquivo inteiro).
