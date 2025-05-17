{{
    config(
        alias='turma_aula_aluno',
        schema='brutos_gestao_escolar',
        partition_by={
            "field": "data_particao",
            "data_type": "date",
            "granularity": "month",
        }
    )
}}

with source as (
    select * from {{ source('brutos_gestao_escolar_staging', 'turma_aula_aluno') }}
),
renamed as (
    select
        {{ adapter.quote("_airbyte_extracted_at") }} AS loaded_at,
        {{ adapter.quote("alu_id") }} AS id_aluno,
        {{ adapter.quote("mtd_id") }} AS id_matricula_disciplina,
        {{ adapter.quote("mtu_id") }} AS id_matricula_turma,
        {{ adapter.quote("taa_anotacao") }} AS anotacao,
        {{ adapter.quote("taa_dataalteracao") }} AS data_alteracao,
        {{ adapter.quote("taa_datacriacao") }} AS data_criacao,
        {{ adapter.quote("taa_frequencia") }} AS faltas_disciplina_dia,
        {{ adapter.quote("taa_frequenciabitmap") }} AS frequencia_tempo,
        {{ adapter.quote("taa_situacao") }} AS id_situacao,
        {{ adapter.quote("tau_id") }} AS id_aula_disciplina,
        {{ adapter.quote("tud_id") }} AS id_disciplina_turma,
        {{ adapter.quote("usu_iddocentealteracao") }} AS usuario_alteracao,
        {{ adapter.quote("data_particao") }} AS data_particao
    from source
)
select * from renamed