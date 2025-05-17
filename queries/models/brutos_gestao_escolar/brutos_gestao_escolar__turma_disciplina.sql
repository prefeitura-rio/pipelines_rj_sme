{{
    config(
        alias='turma_disciplina', 
        schema='brutos_gestao_escolar',
        materialized='incremental',
        unique_key=['id_disciplina_turma']
    )
}}

with source as (
    select * from {{ source('brutos_gestao_escolar_staging', 'TUR_TurmaDisciplina') }}
    {% if is_incremental() %}
      where _airbyte_extracted_at > (select max(loaded_at) from {{ this }})
    {% endif %}
),

renamed as (
    select
        {{ adapter.quote("_airbyte_extracted_at") }} AS loaded_at,
        {{ adapter.quote("tud_aulaforaperiodonormal") }} AS aula_fora_periodo_normal,
        {{ adapter.quote("tud_cargahorariasemanal") }} AS carga_hora_semanal,
        {{ adapter.quote("tud_codigo") }} AS id_disciplina,
        {{ adapter.quote("tud_dataalteracao") }} AS data_alteracao,
        {{ adapter.quote("tud_datacriacao") }} AS data_criacao,
        {{ adapter.quote("tud_datafim") }} AS data_fim,
        {{ adapter.quote("tud_datainicio") }} AS data_inicio,
        {{ adapter.quote("tud_disciplinaespecial") }} AS disciplina_especial,
        {{ adapter.quote("tud_duracao") }} AS id_duracao,
        {{ adapter.quote("tud_global") }} AS global,
        {{ adapter.quote("tud_id") }} AS id_disciplina_turma,
        {{ adapter.quote("tud_minimomatriculados") }} AS minimo_matriculados,
        {{ adapter.quote("tud_modo") }} AS id_modo,
        {{ adapter.quote("tud_multiseriado") }} AS multiseriado,
        {{ adapter.quote("tud_nome") }} AS nome_disciplina,
        {{ adapter.quote("tud_situacao") }} AS id_situacao,
        {{ adapter.quote("tud_tipo") }} AS id_tipo,
        {{ adapter.quote("tud_vagas") }} AS numero_vagas,
    from source
)

select * from renamed
