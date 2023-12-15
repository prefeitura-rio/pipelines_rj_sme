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
    SAFE_CAST(REGEXP_REPLACE(ano, r'\.0$', '') AS INT64) AS ano,
    SAFE_CAST(REGEXP_REPLACE(cre, r'\.0$', '') AS STRING) AS id_cre,
    SAFE_CAST(REGEXP_REPLACE(tur_id, r'\.0$', '') AS STRING) AS id_turma,
    SAFE_CAST(REGEXP_REPLACE(turma, r'\.0$', '') AS STRING) AS id_turma_escola,
    SAFE_CAST(REGEXP_REPLACE(unidade, r'\.0$', '') AS STRING) AS id_unidade,
    SAFE_CAST(grupamento AS STRING) AS grupamento,
    SAFE_CAST(turno AS STRING) AS turno,
    SAFE_CAST(REGEXP_REPLACE(coc, r'\.0$', '') AS STRING) AS id_coc,
    SAFE_CAST(REGEXP_REPLACE(alunos, r'\.0$', '') AS INT64) AS alunos,
    SAFE_CAST(REGEXP_REPLACE(masculinos, r'\.0$', '') AS INT64) AS masculino,
    SAFE_CAST(REGEXP_REPLACE(femininos, r'\.0$', '') AS INT64) AS feminino,
    SAFE_CAST(REGEXP_REPLACE(def, r'\.0$', '') AS INT64) AS deficiente,
    SAFE_CAST(REGEXP_REPLACE(masculinos_def, r'\.0$', '') AS INT64) AS masculino_deficiente,
    SAFE_CAST(REGEXP_REPLACE(femininos_def, r'\.0$', '') AS INT64) AS feminino_deficiente,
    SAFE_CAST(REGEXP_REPLACE(nao_def, r'\.0$', '') AS INT64) AS nao_deficiente,
    SAFE_CAST(REGEXP_REPLACE(masculinos_nao_def, r'\.0$', '') AS INT64) AS masculino_nao_deficiente,
    SAFE_CAST(REGEXP_REPLACE(femininos_nao_def, r'\.0$', '') AS INT64) AS feminino_nao_deficiente,
    SAFE_CAST(REGEXP_REPLACE(vagas, r'\.0$', '') AS INT64) AS vagas, ## valor negativo? superlotacao?
    SAFE_CAST(data_particao AS DATE) data_particao,
FROM `rj-sme.educacao_basica_staging.coc_test`
WHERE SAFE_CAST(data_particao AS DATE) < CURRENT_DATE('America/Sao_Paulo')

{% if is_incremental() %}

{% set max_partition = run_query("SELECT gr FROM (SELECT IF(max(data_particao) > CURRENT_DATE('America/Sao_Paulo'), CURRENT_DATE('America/Sao_Paulo'), max(data_particao)) as gr FROM " ~ this ~ ")").columns[0].values()[0] %}

AND
    SAFE_CAST(data_particao AS DATE) > ("{{ max_partition }}")

{% endif %}
