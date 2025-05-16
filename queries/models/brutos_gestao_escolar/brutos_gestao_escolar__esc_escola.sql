{{ config(alias='esc_escola', schema='brutos_gestao_escolar') }}

with source as (
        select * from {{ source('brutos_gestao_escolar_staging', 'ESC_Escola') }}
  ),
  renamed as (
      select
        {{ adapter.quote("cid_id") }},
        {{ adapter.quote("ent_id") }},
        {{ adapter.quote("esc_id") }},
        {{ adapter.quote("tre_id") }},
        {{ adapter.quote("uad_id") }},
        {{ adapter.quote("esc_nome") }},
        {{ adapter.quote("esc_codigo") }},
        {{ adapter.quote("esc_situacao") }},
        {{ adapter.quote("esc_atoCriacao") }},
        {{ adapter.quote("esc_autorizada") }},
        {{ adapter.quote("esc_codigoInep") }},
        {{ adapter.quote("esc_fundoVerso") }},
        {{ adapter.quote("esc_dataCriacao") }},
        {{ adapter.quote("esc_dataAlteracao") }},
        {{ adapter.quote("esc_microareaCampo") }},
        {{ adapter.quote("esc_controleSistema") }},
        {{ adapter.quote("esc_funcionamentoFim") }},
        {{ adapter.quote("uad_idSuperiorGestao") }},
        {{ adapter.quote("esc_funcionamentoInicio") }},
        {{ adapter.quote("esc_codigoNumeroMatricula") }},
        {{ adapter.quote("esc_dataPublicacaoDiarioOficial") }}

      from source
  )
  select * from renamed
    
