SELECT
    SAFE_CAST(tur_id AS STRING) AS id_turma,
    SAFE_CAST(tud_id AS STRING) AS id_disciplina
FROM `rj-sme.educacao_basica_frequencia_staging.turma_disciplina_rel`