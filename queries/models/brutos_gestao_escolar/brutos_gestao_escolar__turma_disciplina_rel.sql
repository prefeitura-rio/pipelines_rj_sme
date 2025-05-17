{{ config(
        alias='turma_disciplina_rel', 
        schema='brutos_gestao_escolar',
        materialized='incremental',
        unique_key=['id_disciplina', 'id_turma'])
    }}

with source as (
    select * from {{ source('brutos_gestao_escolar_staging', 'TUR_TurmaRelTurmaDisciplina') }}
    {% if is_incremental() %}
      where _airbyte_extracted_at > (select max(loaded_at) from {{ this }})
    {% endif %}
),

renamed as (
    select
        {{ adapter.quote("_airbyte_extracted_at") }} AS loaded_at,
        {{ adapter.quote("tud_id") }} AS id_disciplina,
        {{ adapter.quote("tur_id") }} AS id_turma
    from source
)

select * from renamed