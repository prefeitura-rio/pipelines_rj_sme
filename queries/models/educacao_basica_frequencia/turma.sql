SELECT
    SAFE_CAST(ano AS INT64) AS ano,
    SAFE_CAST(curso AS STRING) AS curso,
    SAFE_CAST(nivel_ensino AS STRING) AS nivel_ensino,
    SAFE_CAST(modalidade AS STRING) AS modalidade,
    SAFE_CAST(grupamento AS STRING) AS grupamento,
    SAFE_CAST(turma AS STRING) AS turma,
    SAFE_CAST(turno AS STRING) AS turno,
    SAFE_CAST(sala AS STRING) AS sala,
    SAFE_CAST(area_sala AS INT64) AS area_sala,
    SAFE_CAST(capac_sala AS INT64) AS capac_sala,
    SAFE_CAST(tipo_sala AS STRING) AS tipo_sala,
    SAFE_CAST(sala_util_como AS STRING) AS sala_util_como,
    SAFE_CAST(tot_turma AS INT64) AS tot_turma,
    SAFE_CAST(tur_id AS STRING) AS tur_id,
    SAFE_CAST(esc_id AS STRING) AS esc_id,
    SAFE_CAST(dep_id AS STRING) AS dep_id
FROM `rj-sme.educacao_basica_frequencia_staging.turma`