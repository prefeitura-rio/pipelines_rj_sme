{{
    config(
        alias='turma_aula',
        schema='brutos_gestao_escolar',
        materialized='incremental',
        unique_key=['id_disciplina', 'id_aula_disciplina']
    )
}}

with source as (
    select * from {{ source('brutos_gestao_escolar_staging', 'CLS_TurmaAula') }}
    {% if is_incremental() %}
      where _airbyte_extracted_at > (select max(loaded_at) from {{ this }})
    {% endif %}
),

renamed as (
    select
        {{ adapter.quote("_airbyte_extracted_at") }} AS loaded_at,
        {{ adapter.quote("tau_atividadecasa") }} as atividade_casa,
        {{ adapter.quote("tau_conteudo") }} as conteudo,
        {{ adapter.quote("tau_data") }} as data_aula,
        {{ adapter.quote("tau_dataalteracao") }} as data_alteracao,
        {{ adapter.quote("tau_datacriacao") }} as data_criacao,
        {{ adapter.quote("tau_diarioclasse") }} as diario_classe,
        {{ adapter.quote("tau_efetivado") }} as efetivado,
        {{ adapter.quote("tau_id") }} as id_aula_disciplina,
        {{ adapter.quote("tau_numeroaulas") }} as numero_aula,
        {{ adapter.quote("tau_planoaula") }} as plano_aula,
        {{ adapter.quote("tau_recursosutilizados") }} as recursos_utilizados,
        {{ adapter.quote("tau_sequencia") }} as sequencia_aula,
        {{ adapter.quote("tau_situacao") }} as id_situacao,
        {{ adapter.quote("tau_statusanotacoes") }} as status_anotacoes,
        {{ adapter.quote("tau_statusplanoaula") }} as status_plano_aula,
        {{ adapter.quote("tdt_posicao") }} as posicao_docente,
        {{ adapter.quote("tpc_id") }} as id_tipo_calendario,
        {{ adapter.quote("tud_id") }} as id_disciplina,
        {{ adapter.quote("usu_id") }} as id_usuario_criacao,
        {{ adapter.quote("usu_iddocentealteracao") }} as id_usuario_alteracao,
        {{ adapter.quote("data_particao") }} as data_particao
    from source
)
select * from renamed
