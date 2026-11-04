# Sprint 3 — Mastering Relational and Non-Relational Database

Entrega da 3ª Sprint do Challenge Vetly. Schema, procedures, funções e trigger
são **fiéis ao projeto real**: as tabelas usadas aqui (`TB_USUARIO`, `TB_PESSOA`,
`TB_ESPECIE`, `TB_TUTOR`, `TB_VETERINARIO`, `TB_ANIMAL`, `TB_CONSULTA`) têm as
mesmas colunas, tipos e constraints de `vetly-database/DDL.txt`, que por sua vez
espelha as migrations Flyway de `mvc-vetly-java` (`src/main/resources/db/migration/V1..V9`)
— o backend/conexão principal do projeto na geração atual (GEN 2).

Este diretório é **autocontido**: cria suas próprias tabelas do zero (não depende
de `../procedures/` nem de `../migrations/` já terem rodado), para poder ser
executado em qualquer schema Oracle vazio, exatamente como a entrega será avaliada.

## Arquivos

| Ordem | Arquivo | Conteúdo | Requisito atendido |
|---|---|---|---|
| 1 | `01_ddl_estrutura.sql` | `CREATE TABLE` de todas as tabelas usadas + `TB_AUDITORIA` | Estrutura completa |
| 2 | `02_carga_dados.sql` | `INSERT INTO`, ≥5 registros válidos por tabela | Carga de dados |
| 3 | `03_funcoes.sql` | `SP_REGISTRA_LOG` (auxiliar de log) + **Função 1** `FN_MONTA_JSON_ANIMAL` + **Função 2** `FN_VALIDA_CPF` | Funções (30 pts) |
| 4 | `04_procedures.sql` | **Procedimento 1** `PRC_LISTA_ANIMAIS_TUTORES_JSON` + **Procedimento 2** `PRC_RELATORIO_CONSULTAS_VET_STATUS` | Procedimentos (30 pts) |
| 5 | `05_trigger_auditoria.sql` | `TRG_AUD_CONSULTA` (AFTER INSERT/UPDATE/DELETE) | Trigger (30 pts) |
| 6 | `06_testes_execucao.sql` | Caminho feliz + exceções tratadas de cada objeto (para os prints do PDF) | Documentação/execução |
| — | `2TDSPW_2026_CodigoSql_Integrantes.sql` | **Concatenação de 1–6, na ordem certa** — é o arquivo `.sql` final da entrega | Arquivo SQL exigido |
| — | `prints-execucao/` | 25 capturas de tela da execução real (SQL Developer) de cada objeto, caminho feliz + exceções | Prints exigidos no PDF |
| — | `2TDSPW_2026_Proj_BD.docx` | Documento com capa, mapeamento dos requisitos e todos os prints + código-fonte completo em anexo | Arquivo PDF exigido (exportar para `.pdf` antes do envio) |
| — | `docx_build/build_doc.py` | Script Python (`python-docx`) que gera o `.docx` acima a partir de `prints-execucao/` | — |

Para rodar manualmente: execute os arquivos `01` a `06` nessa ordem (SQL*Plus,
SQL Developer, DBeaver etc.), ou rode direto o arquivo consolidado
`2TDSPW_2026_CodigoSql_Integrantes.sql`. Antes de rodar, garanta `SET SERVEROUTPUT ON`
na sessão para ver as saídas de `DBMS_OUTPUT`.

## Mapeamento para os requisitos do enunciado

**Procedimento 1** (`PRC_LISTA_ANIMAIS_TUTORES_JSON`)
- JOIN entre `TB_ANIMAL` + `TB_ESPECIE` + `TB_TUTOR` + `TB_PESSOA` (4 tabelas).
- Exibe cada linha como JSON, montado por `FN_MONTA_JSON_ANIMAL` (Função 1) — nenhuma
  função pronta de JSON do Oracle é usada.
- 4 tabelas com ≥5 registros válidos cada (`02_carga_dados.sql`).
- 3+ exceções tratadas: tutor de filtro inexistente (`-20002`), nenhum animal
  encontrado (`-20003`), `VALUE_ERROR`, `OTHERS`.

**Procedimento 2** (`PRC_RELATORIO_CONSULTAS_VET_STATUS`)
- Tabela de fatos `TB_CONSULTA`: categorias = veterinário + status da consulta,
  numérico = `VL_CONSULTA`.
- Soma por combinação completa (veterinário, status), subtotal por veterinário
  e total geral — tudo calculado com variáveis acumuladoras e um cursor
  ordenado (`ORDER BY` veterinário, status), **sem** `SUM()`/`GROUP BY`/`ROLLUP`/
  `CUBE`/`GROUPING SETS`/`GROUPING`.
- Linhas de subtotal e total geral saem na mesma coluna/linha da combinação
  detalhada, com as categorias ausentes como `NULL` (exibidas como `-` na saída
  de texto, já que `DBMS_OUTPUT` não imprime `NULL` literal).
- 6 linhas de fato (`02_carga_dados.sql`), cruzando 2 veterinários × 3 status.
- 3+ exceções: tabela de fatos vazia (`-20004`), `VALUE_ERROR` (valor nulo em
  uma linha de fato), `OTHERS`.

**Função 1** (`FN_MONTA_JSON_ANIMAL`)
- Recebe dados relacionais (colunas já lidas do JOIN) e retorna uma string JSON
  montada por concatenação (`||`), com uma subrotina local (`FN_ESCAPA_JSON`)
  que escapa aspas/barra invertida/quebra de linha caractere a caractere.
- Nenhuma função pronta de JSON do Oracle (`TO_JSON`, `JSON_OBJECT`, `JSON_VALUE`,
  `JSON_QUERY`, `JSON_TABLE`) é usada.
- 3+ exceções: campo obrigatório nulo (`-20001`), `VALUE_ERROR`, `OTHERS`.

**Função 2** (`FN_VALIDA_CPF`)
- Substitui um processo de validação que hoje não existe no projeto: `SP_INS_PESSOA`
  aceita qualquer `VARCHAR2(11)` em `CPF_PESSOA` sem checar o dígito verificador.
- Implementa o algoritmo oficial de módulo 11 (2 dígitos verificadores) +
  rejeição de sequências repetidas (`111.111.111-11` etc., que passam no
  módulo 11 mas são inválidas na prática).
- 3+ exceções: CPF nulo (`-20011`), tamanho inválido (`-20012`), `INVALID_NUMBER`
  (caracteres não numéricos, tratada e retorna `'N'`), `OTHERS`.

**Trigger** (`TRG_AUD_CONSULTA`)
- `TB_AUDITORIA` com usuário (`USER`), tipo de operação, data/hora, valores
  antigos e novos.
- `AFTER INSERT OR UPDATE OR DELETE ON TB_CONSULTA FOR EACH ROW`, grava uma
  linha por operação, usando `:OLD`/`:NEW` formatados manualmente.
- Nunca derruba a operação de negócio que a disparou (falha ao auditar vai
  para `TB_LOG_ERRO`, não interrompe o DML original).

## Documento de entrega (`2TDSPW_2026_Proj_BD.docx` → exportar para `.pdf`)

`2TDSPW_2026_Proj_BD.docx` já foi gerado a partir das execuções reais em
`prints-execucao/` (SQL Developer, conexão `fiap`, usuário `RM565754`) e contém:
capa com os 4 integrantes em ordem alfabética, mapeamento de cada requisito do
enunciado, prints de criação de estrutura, carga de dados, compilação de cada
função/procedure/trigger, testes de caminho feliz + exceção de cada objeto, os
registros gravados em `TB_AUDITORIA` pela trigger, o log de exceções em
`TB_LOG_ERRO`, e o código-fonte completo do `.sql` como apêndice comentado.

Para regenerar o `.docx` depois de novas execuções/prints:
```
python3 -m venv /tmp/docxvenv && /tmp/docxvenv/bin/pip install python-docx
/tmp/docxvenv/bin/python docx_build/build_doc.py
```

## Pendências antes do envio

1. Abrir `2TDSPW_2026_Proj_BD.docx` no Word/LibreOffice, revisar a formatação
   (quebras de página, tamanho das imagens) e exportar como
   `2TDSPW_2026_Proj_BD.pdf`.
2. Incluir no PDF o código corrigido da 2ª Sprint conforme feedback recebido
   (`../blocos-anonimos/` e `../relatorios/`, já existentes neste repositório) —
   a Seção 10 do documento só referencia esses arquivos, o conteúdo revisado
   ainda precisa ser colado/anexado manualmente.
3. Conferir se o print `dados-inseridos-tb_exame.png` (tabela `TB_EXAME`, fora
   do escopo desta entrega) deve ser removido de `prints-execucao/` ou se
   pertence a outra parte do trabalho — ele não foi incluído no `.docx`.
