{{ config(alias='turma_curriculo', schema='educacao_basica_frequencia') }}

SELECT
    SAFE_CAST(REGEXP_REPLACE(TRIM(crp_id), r'\.0$', '') AS STRING) AS id_periodo_curriculo,
    SAFE_CAST(REGEXP_REPLACE(TRIM(crr_id), r'\.0$', '') AS STRING) AS id_curriculo,
    SAFE_CAST(REGEXP_REPLACE(TRIM(cur_id), r'\.0$', '') AS STRING) AS id_curso,
    SAFE_CAST(TRIM(tcr_dataalteracao) AS DATETIME ) AS data_alteracao,
    SAFE_CAST(TRIM(tcr_datacriacao) AS DATETIME ) AS data_criacao,
    SAFE_CAST(REGEXP_REPLACE(TRIM(tcr_prioridade), r'\.0$', '') AS INT64) AS prioridade_curriculo,
    SAFE_CAST(REGEXP_REPLACE(TRIM(tcr_situacao), r'\.0$', '') AS STRING) AS id_situacao,
    SAFE_CAST(REGEXP_REPLACE(TRIM(tur_id), r'\.0$', '') AS STRING) AS id_turma,
FROM `rj-sme.educacao_basica_frequencia_staging.turma_curriculo` AS t