{{
    config(alias='turma_aula_aluno', schema='educacao_basica_frequencia',
    partition_by={
        "field": "data_particao",
        "data_type": "date",
        "granularity": "month",
    })
}}

SELECT
    SAFE_CAST(REGEXP_REPLACE(TRIM(alu_id), r'\.0$', '') AS STRING) AS id_aluno,
    SAFE_CAST(REGEXP_REPLACE(TRIM(mtd_id), r'\.0$', '') AS STRING) AS id_matricula_disciplina,
    SAFE_CAST(REGEXP_REPLACE(TRIM(mtu_id), r'\.0$', '') AS STRING) AS id_matricula_turma,
    SAFE_CAST(TRIM(taa_anotacao) AS STRING) AS anotacao,
    SAFE_CAST(TRIM(taa_dataalteracao) AS DATETIME ) AS data_alteracao,
    SAFE_CAST(TRIM(taa_datacriacao) AS DATETIME ) AS data_criacao,
    SAFE_CAST(REGEXP_REPLACE(TRIM(taa_frequencia), r'\.0$', '') AS INT64) AS faltas_disciplina_dia,
    SAFE_CAST(TRIM(taa_frequenciabitmap) AS STRING) AS frequencia_tempo,
    SAFE_CAST(REGEXP_REPLACE(TRIM(taa_situacao), r'\.0$', '') AS STRING) AS id_situacao,
    SAFE_CAST(REGEXP_REPLACE(TRIM(tau_id), r'\.0$', '') AS STRING) AS id_aula_disciplina,
    SAFE_CAST(REGEXP_REPLACE(TRIM(tud_id), r'\.0$', '') AS STRING) AS id_disciplina_turma,
    SAFE_CAST(TRIM(usu_iddocentealteracao) AS STRING) AS usuario_alteracao,
    SAFE_CAST(data_particao AS DATE) AS data_particao

FROM `rj-sme.educacao_basica_frequencia_staging.turma_aula_aluno` AS t