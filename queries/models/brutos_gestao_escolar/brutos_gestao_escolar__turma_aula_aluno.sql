{{
    config(
        alias='turma_aula_aluno',
        schema='brutos_gestao_escolar',
        materialized='incremental',
        unique_key=['id_aluno', 'id_matricula_disciplina','id_matricula_turma','id_aula_disciplina','id_disciplina_turma']
    )
}}

with source as (
    select * from {{ source('educacao_basica_frequencia_staging', 'CLS_TurmaAulaAluno') }}
    {% if is_incremental() %}
      where data_particao > (select max(data_particao) from {{ this }})
    {% endif %}
),
renamed as (
    select
        SAFE_CAST(REGEXP_REPLACE(TRIM({{ adapter.quote("alu_id") }}), r'\.0$', '') AS STRING) AS id_aluno,
        SAFE_CAST(REGEXP_REPLACE(TRIM({{ adapter.quote("mtd_id") }}), r'\.0$', '') AS STRING) AS id_matricula_disciplina,
        SAFE_CAST(REGEXP_REPLACE(TRIM({{ adapter.quote("mtu_id") }}), r'\.0$', '') AS STRING) AS id_matricula_turma,
        SAFE_CAST(REGEXP_REPLACE(TRIM({{ adapter.quote("taa_anotacao") }}), r'\.0$', '') AS STRING) AS anotacao,
        SAFE_CAST({{ adapter.quote("taa_dataalteracao") }} AS TIMESTAMP) AS data_alteracao,
        SAFE_CAST({{ adapter.quote("taa_datacriacao") }} AS TIMESTAMP) AS data_criacao,
        SAFE_CAST(REGEXP_REPLACE(TRIM({{ adapter.quote("taa_frequencia") }}), r'\.0$', '') AS STRING) AS faltas_disciplina_dia,
        SAFE_CAST(REGEXP_REPLACE(TRIM({{ adapter.quote("taa_frequenciabitmap") }}), r'\.0$', '') AS STRING) AS frequencia_tempo,
        SAFE_CAST(REGEXP_REPLACE(TRIM({{ adapter.quote("taa_situacao") }}), r'\.0$', '') AS STRING) AS id_situacao,
        SAFE_CAST(REGEXP_REPLACE(TRIM({{ adapter.quote("tau_id") }}), r'\.0$', '') AS STRING) AS id_aula_disciplina,
        SAFE_CAST(REGEXP_REPLACE(TRIM({{ adapter.quote("tud_id") }}), r'\.0$', '') AS STRING) AS id_disciplina_turma,
        SAFE_CAST(REGEXP_REPLACE(TRIM({{ adapter.quote("usu_iddocentealteracao") }}), r'\.0$', '') AS STRING) AS usuario_alteracao,
    from source
)
select * from renamed