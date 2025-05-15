{{
    config(
        alias='turma_aula',
        schema='brutos_gestao_escolar',
        materialized='incremental',
        unique_key=['id_disciplina', 'id_aula_disciplina'],
    )
}}

WITH fonte AS (
    SELECT
        SAFE_CAST(TRIM(tau_atividadecasa) AS STRING) AS atividade_casa,
        SAFE_CAST(TRIM(tau_conteudo) AS STRING) AS conteudo,
        SAFE_CAST(DATE(tau_data) AS DATE) AS data_aula,
        SAFE_CAST(TRIM(tau_dataalteracao) AS DATETIME ) AS data_alteracao,
        SAFE_CAST(TRIM(tau_datacriacao) AS DATETIME ) AS data_criacao,
        SAFE_CAST(TRIM(tau_diarioclasse) AS STRING) AS diario_classe,
        SAFE_CAST(TRIM(tau_efetivado) AS BOOL) AS efetivado,
        SAFE_CAST(REGEXP_REPLACE(TRIM(tau_id), r'\.0$', '') AS INT64) AS id_aula_disciplina,
        SAFE_CAST(REGEXP_REPLACE(TRIM(tau_numeroaulas), r'\.0$', '') AS INT64) AS numero_aula,
        SAFE_CAST(TRIM(tau_planoaula) AS STRING) AS plano_aula,
        SAFE_CAST(TRIM(tau_recursosutilizados) AS STRING) AS recursos_utilizados,
        SAFE_CAST(REGEXP_REPLACE(TRIM(tau_sequencia), r'\.0$', '') AS INT64) AS sequencia_aula,
        SAFE_CAST(REGEXP_REPLACE(TRIM(tau_situacao), r'\.0$', '') AS STRING) AS id_situacao,
        SAFE_CAST(TRIM(tau_statusanotacoes) AS STRING) AS status_anotacoes,
        SAFE_CAST(TRIM(tau_statusplanoaula) AS STRING) AS status_plano_aula,
        SAFE_CAST(TRIM(tdt_posicao) AS STRING) AS posicao_docente,
        SAFE_CAST(REGEXP_REPLACE(TRIM(tpc_id), r'\.0$', '') AS STRING) AS id_tipo_calendario,
        SAFE_CAST(REGEXP_REPLACE(TRIM(tud_id), r'\.0$', '') AS STRING) AS id_disciplina,
        SAFE_CAST(REGEXP_REPLACE(TRIM(usu_id), r'\.0$', '') AS STRING) AS id_usuario_criacao,
        SAFE_CAST(REGEXP_REPLACE(TRIM(usu_iddocentealteracao), r'\.0$', '') AS STRING) AS id_usuario_alteracao,
        SAFE_CAST(data_particao AS DATE) AS data_particao
    FROM {{ source('educacao_basica_frequencia_staging', 'turma_aula') }} AS t
    {% if is_incremental() %}
      WHERE SAFE_CAST(TRIM(tau_dataalteracao) AS DATETIME) > (SELECT MAX(data_alteracao) FROM {{ this }})
    {% endif %}
)

SELECT * FROM fonte