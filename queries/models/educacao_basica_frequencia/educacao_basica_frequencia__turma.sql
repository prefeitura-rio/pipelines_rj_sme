{{ config(alias='turma', schema='educacao_basica_frequencia') }}

SELECT
    SAFE_CAST(REGEXP_REPLACE(TRIM(ano), r'\.0$', '') AS INT64) AS ano,
    SAFE_CAST(REGEXP_REPLACE(area_sala, r',', '.') AS FLOAT64) AS area_sala,
    SAFE_CAST(REGEXP_REPLACE(TRIM(capac_sala), r'\.0$', '') AS INT64) AS capacidade_sala,
    SAFE_CAST(TRIM(curso) AS STRING) AS curso,
    SAFE_CAST(REGEXP_REPLACE(TRIM(dep_id), r'\.0$', '') AS STRING) AS id_dependencia,
    SAFE_CAST(REGEXP_REPLACE(TRIM(esc_id), r'\.0$', '') AS STRING) AS id_escola,
    SAFE_CAST(TRIM(grupamento) AS STRING) AS grupamento,
    SAFE_CAST(TRIM(modalidade) AS STRING) AS modalidade,
    SAFE_CAST(TRIM(nivel_ensino) AS STRING) AS nivel_ensino,
    SAFE_CAST(TRIM(sala) AS STRING) AS sala,
    SAFE_CAST(TRIM(sala_util_como) AS STRING) AS sala_util_como,
    SAFE_CAST(TRIM(tipo_sala) AS STRING) AS tipo_sala,
    SAFE_CAST(REGEXP_REPLACE(TRIM(tur_id), r'\.0$', '') AS STRING) AS id_turma,
    SAFE_CAST(REGEXP_REPLACE(TRIM(turma), r'\.0$', '') AS STRING) AS id_turma_escola,
    SAFE_CAST(TRIM(turno) AS STRING) AS turno,
FROM `rj-sme.educacao_basica_frequencia_staging.turma` AS t