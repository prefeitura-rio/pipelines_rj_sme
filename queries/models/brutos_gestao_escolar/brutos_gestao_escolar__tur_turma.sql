{{ config(alias='tur_turma', schema='brutos_gestao_escolar') }}

with source as (
        select * from {{ source('brutos_gestao_escolar_staging', 'TUR_Turma') }}
  ),
  renamed as (
      select
        {{ adapter.quote("_airbyte_extracted_at") }} AS loaded_at,
        {{ adapter.quote("cal_id") }},
        {{ adapter.quote("dep_id") }},
        {{ adapter.quote("esc_id") }},
        {{ adapter.quote("fav_id") }},
        {{ adapter.quote("prd_id") }},
        {{ adapter.quote("trn_id") }},
        {{ adapter.quote("tur_id") }},
        {{ adapter.quote("uni_id") }},
        {{ adapter.quote("tur_tipo") }},
        {{ adapter.quote("tur_vagas") }},
        {{ adapter.quote("tur_codigo") }},
        {{ adapter.quote("tur_duracao") }},
        {{ adapter.quote("tur_situacao") }},
        {{ adapter.quote("tur_descricao") }},
        {{ adapter.quote("tur_codigoInep") }},
        {{ adapter.quote("tur_observacao") }},
        {{ adapter.quote("tur_seqChamada") }},
        {{ adapter.quote("tur_dataCriacao") }},
        {{ adapter.quote("tur_dataAlteracao") }},
        {{ adapter.quote("tur_dataEncerramento") }},
        {{ adapter.quote("tur_participaRodizio") }},
        {{ adapter.quote("tur_flag_tem_acrescimo") }},
        {{ adapter.quote("tur_minimoMatriculados") }},
        {{ adapter.quote("tur_docenteEspecialista") }}

      from source
  )
  select * from renamed