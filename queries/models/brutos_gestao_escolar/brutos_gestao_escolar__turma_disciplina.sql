{{
    config(
        alias='turma_disciplina', schema='brutos_gestao_escolar',
        partition_by={
            "field": "data_particao",
            "data_type": "date",
            "granularity": "month",
        }
    )
}}

SELECT
    SAFE_CAST(TRIM(tud_aulaforaperiodonormal) AS BOOL) AS aula_fora_periodo_normal,
    SAFE_CAST(REGEXP_REPLACE(TRIM(tud_cargahorariasemanal), r'\.0$', '') AS INT64) AS carga_hora_semanal,
    SAFE_CAST(REGEXP_REPLACE(TRIM(tud_codigo), r'\.0$', '') AS STRING) AS id_disciplina,
    SAFE_CAST(DATE(tud_dataalteracao) AS DATE) AS data_alteracao,
    SAFE_CAST(DATE(tud_datacriacao) AS DATE) AS data_criacao,
    SAFE_CAST(TRIM(tud_datafim) AS STRING) AS data_fim,
    SAFE_CAST(DATE(tud_datainicio) AS DATE) AS data_inicio,
    SAFE_CAST(TRIM(tud_disciplinaespecial) AS BOOL) AS disciplina_especial,
    SAFE_CAST(REGEXP_REPLACE(TRIM(tud_duracao), r'\.0$', '') AS STRING) AS id_duracao,
    SAFE_CAST(TRIM(tud_global) AS BOOL) AS global,
    SAFE_CAST(REGEXP_REPLACE(TRIM(tud_id), r'\.0$', '') AS STRING) AS id_disciplina_turma,
    SAFE_CAST(REGEXP_REPLACE(TRIM(tud_minimomatriculados), r'\.0$', '') AS INT64) AS minimo_matriculados,
    SAFE_CAST(REGEXP_REPLACE(TRIM(tud_modo), r'\.0$', '') AS STRING) AS id_modo,
    SAFE_CAST(TRIM(tud_multiseriado) AS BOOL) AS multiseriado,
    SAFE_CAST(TRIM(tud_nome) AS STRING) AS nome_disciplina,
    SAFE_CAST(REGEXP_REPLACE(TRIM(tud_situacao), r'\.0$', '') AS STRING) AS id_situacao,
    SAFE_CAST(REGEXP_REPLACE(TRIM(tud_tipo), r'\.0$', '') AS STRING) AS id_tipo,
    SAFE_CAST(REGEXP_REPLACE(TRIM(tud_vagas), r'\.0$', '') AS INT64) AS numero_vagas,
    SAFE_CAST(data_particao AS DATE) AS data_particao
FROM {{ source('educacao_basica_frequencia_staging', 'turma_disciplina') }} AS t
