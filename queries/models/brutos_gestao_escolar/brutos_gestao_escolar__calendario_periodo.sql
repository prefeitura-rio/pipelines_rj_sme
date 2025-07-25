{{ config(alias='calendario_periodo', schema='brutos_gestao_escolar') }}

with source as (
    select * from {{ source('brutos_gestao_escolar_staging', 'ACA_CalendarioPeriodo') }}
),

renamed as (
    select
        {{ adapter.quote("_airbyte_extracted_at") }} AS loaded_at,
        SAFE_CAST({{ adapter.quote("cal_id") }} AS STRING) AS {{ adapter.quote("cal_id") }},
        SAFE_CAST({{ adapter.quote("cap_id") }} AS STRING) AS {{ adapter.quote("cap_id") }},
        {{ adapter.quote("cap_descricao") }},
        SAFE_CAST({{ adapter.quote("tpc_id") }} AS STRING) AS {{ adapter.quote("tpc_id") }},
        {{ adapter.quote("cap_dataInicio") }},
        {{ adapter.quote("cap_dataFim") }},
        {{ adapter.quote("cap_situacao") }},
        {{ adapter.quote("cap_dataCriacao") }},
        {{ adapter.quote("cap_dataAlteracao") }}
    from source
)


select * from renamed
