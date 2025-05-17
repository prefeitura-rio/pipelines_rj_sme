{{ config(alias='turma_curriculo', schema='brutos_gestao_escolar') }}

with source as (
    select * from {{ source('brutos_gestao_escolar_staging', 'TUR_TurmaCurriculo') }}
),

renamed as (
    select
        {{ adapter.quote("_airbyte_extracted_at") }} AS loaded_at,
        {{ adapter.quote("crp_id") }} AS id_periodo_curriculo,
        {{ adapter.quote("crr_id") }} AS id_curriculo,
        {{ adapter.quote("cur_id") }} AS id_curso,
        {{ adapter.quote("tcr_dataalteracao") }} AS data_alteracao,
        {{ adapter.quote("tcr_datacriacao") }} AS data_criacao,
        {{ adapter.quote("tcr_prioridade") }} AS prioridade_curriculo,
        {{ adapter.quote("tcr_situacao") }} AS id_situacao,
        {{ adapter.quote("tur_id") }} AS id_turma
    from source
)

select * from renamed