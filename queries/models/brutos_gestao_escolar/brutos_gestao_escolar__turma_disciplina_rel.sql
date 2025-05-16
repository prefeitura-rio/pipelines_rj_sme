{{ config(alias='turma_disciplina_rel', schema='brutos_gestao_escolar') }}

SELECT
    SAFE_CAST(REGEXP_REPLACE(TRIM(tud_id), r'\.0$', '') AS STRING) AS id_disciplina,
    SAFE_CAST(REGEXP_REPLACE(TRIM(tur_id), r'\.0$', '') AS STRING) AS id_turma,
FROM {{ source('brutos_gestao_escolar_staging', 'TUR_TurmaRelTurmaDisciplina') }} AS t