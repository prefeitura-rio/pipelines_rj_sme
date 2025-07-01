{{ config(
    alias='numeroDeAulasCte',
    materialized='ephemeral',
) }}


with source as (
        select * from {{ source('educacao_basica_frequencia_staging', 'numeroDeAulasCte') }}
  ),
  renamed as (
      select
        {{ adapter.quote("alu_id") }},
        {{ adapter.quote("tpc_id") }},
        CAST({{ adapter.quote("numeroAulas") }} AS INT64) AS numeroAulas,

      from source
  )
  select * from renamed
