{{ config(alias='aluno_turma', schema='educacao_basica') }}

{{
    config(
        materialized='incremental',
        partition_by={
            "field": "data_particao",
            "data_type": "date",
            "granularity": "year",
        }
    )
}}
SELECT
    SAFE_CAST(ano AS INT64) ano,
    SAFE_CAST(REGEXP_REPLACE(tur_id, r'\.0$', '') AS STRING) id_turma,
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
    SAFE_CAST(data_particao AS DATE) data_particao,
FROM `rj-sme.educacao_basica_staging.aluno_turma`
WHERE data_particao < CURRENT_DATE('America/Sao_Paulo')

{% if is_incremental() %}

{% set max_partition = run_query("SELECT gr FROM (SELECT IF(max(data_particao) > CURRENT_DATE('America/Sao_Paulo'), CURRENT_DATE('America/Sao_Paulo'), max(data_particao)) as gr FROM " ~ this ~ ")").columns[0].values()[0] %}

AND
    data_particao > ("{{ max_partition }}")

{% endif %}