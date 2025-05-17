{{ config(
        alias='mtr_matricula_turma',
        schema='brutos_gestao_escolar',
        materialized='incremental',
        unique_key=['alu_id', 'mtu_id']
    )}}

with source as (
    select * from {{ source('brutos_gestao_escolar_staging', 'MTR_MatriculaTurma') }}
    {% if is_incremental() %}
        where _airbyte_extracted_at > (select max(loaded_at) from {{ this }})
    {% endif %}
),
renamed as (
    select
        {{ adapter.quote("_airbyte_extracted_at") }} AS loaded_at,
        {{ adapter.quote("alu_id") }} AS alu_id,
        {{ adapter.quote("mtu_id") }} AS mtu_id,
        {{ adapter.quote("tur_id") }} AS tur_id,
        {{ adapter.quote("cur_id") }} AS cur_id,
        {{ adapter.quote("crr_id") }} AS crr_id,
        {{ adapter.quote("crp_id") }} AS crp_id,
        {{ adapter.quote("mtu_dataMatricula") }} AS mtu_dataMatricula,
        {{ adapter.quote("mtu_avaliacao") }} AS mtu_avaliacao,
        {{ adapter.quote("mtu_frequencia") }} AS mtu_frequencia,
        {{ adapter.quote("mtu_relatorio") }} AS mtu_relatorio,
        {{ adapter.quote("mtu_resultado") }} AS mtu_resultado,
        {{ adapter.quote("mtu_dataSaida") }} AS mtu_dataSaida,
        {{ adapter.quote("mtu_situacao") }} AS mtu_situacao,
        {{ adapter.quote("mtu_dataCriacao") }} AS mtu_dataCriacao,
        {{ adapter.quote("mtu_dataAlteracao") }} AS mtu_dataAlteracao,
        {{ adapter.quote("mtu_numeroChamada") }} AS mtu_numeroChamada,
        {{ adapter.quote("alc_id") }} AS alc_id,
        {{ adapter.quote("usu_idResultado") }} AS usu_idResultado
    from source
)
select * from renamed