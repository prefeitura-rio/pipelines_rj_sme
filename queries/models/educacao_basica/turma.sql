SELECT 
    SAFE_CAST(ano AS INT64) AS ano,
    SAFE_CAST(REGEXP_REPLACE(esc_id, r'\.0$', '') AS STRING) AS id_escola,
    SAFE_CAST(REGEXP_REPLACE(dep_id, r'\.0$', '') AS STRING) AS id_dependencia,
    SAFE_CAST(REGEXP_REPLACE(tur_id, r'\.0$', '') AS STRING) AS id_turma,
    SAFE_CAST(REGEXP_REPLACE(turma, r'\.0$', '') AS STRING) AS id_turma_escola,
    SAFE_CAST(curso AS STRING) AS curso,
    SAFE_CAST(nivel_ensino AS STRING) AS nivel_ensino,
    SAFE_CAST(REGEXP_REPLACE(modalidade, r'\.0$', '') AS STRING) AS modalidade,
    SAFE_CAST(grupamento AS STRING) AS grupamento,
    SAFE_CAST(turno AS STRING) AS turno,
    SAFE_CAST(sala AS STRING) AS sala,
    SAFE_CAST(REGEXP_REPLACE(area_sala, r',', '.') AS FLOAT64) AS area_sala,
    SAFE_CAST(REGEXP_REPLACE(capac_sala, r'\.0$', '') AS INT64) AS capacidade_sala,
    SAFE_CAST(tipo_sala AS STRING) AS tipo_sala,
    SAFE_CAST(sala_util_como AS STRING) AS sala_util_como
FROM `rj-sme.educacao_basica_staging.turma`
