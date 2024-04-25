{{ config(alias='turma_disciplina_rel', schema='educacao_basica_frequencia') }}

SELECT
    SAFE_CAST(REGEXP_REPLACE(TRIM(tud_id), r'\.0$', '') AS STRING) AS id_disciplina,
    SAFE_CAST(REGEXP_REPLACE(TRIM(tur_id), r'\.0$', '') AS STRING) AS id_turma,
FROM `rj-sme.educacao_basica_frequencia_staging.turma_disciplina_rel` AS t