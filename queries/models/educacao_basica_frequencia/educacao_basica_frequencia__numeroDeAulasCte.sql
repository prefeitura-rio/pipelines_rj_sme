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
        {{ adapter.quote("mtu_id") }},
        {{ adapter.quote("tpc_id") }},
        {{ adapter.quote("numeroAulas") }},

      from source
  )
  select * from renamed
