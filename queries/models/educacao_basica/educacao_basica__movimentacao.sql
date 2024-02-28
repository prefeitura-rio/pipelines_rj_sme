{{ config(alias='movimentacao', schema='educacao_basica') }}

{{
    config(
        materialized='incremental',
        partition_by={
            "field": "data_particao",
            "data_type": "date",
            "granularity": "month",
        }
    )
}}

SELECT
    SAFE_CAST(REGEXP_REPLACE(ano, r'\.0$', '') AS INT64) AS ano,
    SAFE_CAST(REGEXP_REPLACE(cre, r'\.0$', '') AS STRING) AS id_cre,
    SAFE_CAST(REGEXP_REPLACE(coc, r'\.0$', '') AS STRING) AS id_coc,
    SAFE_CAST(REGEXP_REPLACE(unidade, r'\.0$', '') AS STRING) AS id_unidade,
    SAFE_CAST(REGEXP_REPLACE(turma, r'\.0$', '') AS STRING) AS id_turma_escola,
    SAFE_CAST(grupamento AS STRING) AS grupamento,
    SUBSTR(SHA256(
        CONCAT(
            '{{ var("hash_seed") }}',
            SAFE_CAST(REGEXP_REPLACE(alu_id, r'\.0$', '')  AS STRING)
        )
    ), 2,17) as  id_aluno,
    SUBSTR(SHA256(
        CONCAT(
            '{{ var("hash_seed") }}',
            SAFE_CAST(REGEXP_REPLACE(alu_id, r'\.0$', '')  AS STRING),
            SAFE_CAST(ano AS STRING)
        )
    ), 2,17) as  id_aluno_ano,
    SAFE_CAST(aluno AS STRING) AS matricula,
    SAFE_CAST(sexo AS STRING) AS genero,
    SAFE_CAST(REGEXP_REPLACE(cod_def, r'\.0$', '') AS STRING) AS id_deficiencia,
    SAFE_CAST(deficiencia AS STRING) AS deficiencia,
    SAFE_CAST(datanascimento AS DATE) AS data_nascimentoo,
    SAFE_CAST(REGEXP_REPLACE(idade_atual, r'\.0$', '') AS INT64) AS idade_atual,
    SAFE_CAST(REGEXP_REPLACE(idade_3112, r'\.0$', '') AS INT64) AS idade_final_ano,
    SAFE_CAST(data_mov AS DATE) AS data_movimentacao,
    SAFE_CAST(REGEXP_REPLACE(cod_mov, r'\.0$', '') AS STRING) AS id_movimentacao,
    SAFE_CAST(movimentacao AS STRING) AS movimentacao,
    SAFE_CAST(mov_ordem AS STRING) AS ordem,
    SAFE_CAST(tipo_mov AS STRING) AS tipo,
    SAFE_CAST(data_particao AS DATE) data_particao,
FROM `rj-sme.educacao_basica_staging.movimentacao`
WHERE data_particao < CURRENT_DATE('America/Sao_Paulo')

{% if is_incremental() %}

{% set max_partition = run_query("SELECT gr FROM (SELECT IF(max(data_particao) > CURRENT_DATE('America/Sao_Paulo'), CURRENT_DATE('America/Sao_Paulo'), max(data_particao)) as gr FROM " ~ this ~ ")").columns[0].values()[0] %}

AND
    data_particao > ("{{ max_partition }}")

{% endif %}