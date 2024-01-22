{{ config(alias='turma_aula', schema='educacao_basica_frequencia', materialized='incremental',
        partition_by={
            "field": "tau_dataAlteracao",
            "data_type": "date",
            "granularity": "month",
        }) }}

SELECT
    SAFE_CAST(tau_id AS STRING) AS id_aula_disciplina,
    SAFE_CAST(tau_sequencia AS INT64) AS sequencia_aula,
    SAFE_CAST(tau_data AS DATE) AS data_aula,
    SAFE_CAST(tau_numeroAulas AS INT64) AS numero_aula,
    SAFE_CAST(tau_planoAula AS STRING) AS plano_aula,
    SAFE_CAST(tau_diarioClasse AS STRING) AS diario_classe,
    SAFE_CAST(tau_situacao AS INT64) AS situacao,
    SAFE_CAST(tau_dataCriacao AS DATETIME) AS data_criacao,
    SAFE_CAST(tau_dataAlteracao AS DATETIME) AS data_alteracao,
    SAFE_CAST(tau_conteudo AS STRING) AS conteudo,
    SAFE_CAST(tau_efetivado AS BOOL) AS efetivado,
    SAFE_CAST(tau_atividadeCasa AS STRING) AS atividade_casa,
    SAFE_CAST(tdt_posicao AS INT64) AS posicao_docente,
    SAFE_CAST(pro_id AS STRING) AS pro_id,
    SAFE_CAST(tau_sintese AS STRING) AS tau_sintese,
    SAFE_CAST(tau_reposicao AS BOOL) AS tau_reposicao,
    SAFE_CAST(usu_id AS STRING) AS id_usuario_criacao,
    SAFE_CAST(usu_idDocenteAlteracao AS STRING) AS id_usuario_alteracao,
    SAFE_CAST(tau_statusFrequencia AS INT64) AS status_frequencia,
    SAFE_CAST(tau_statusAtividadeAvaliativa AS INT64) AS status_atividade_avaliativa,
    SAFE_CAST(tau_statusAnotacoes AS INT64) AS status_anotacoes,
    SAFE_CAST(tau_statusPlanoAula AS INT64) AS status_plano_aula,
    SAFE_CAST(tpc_id AS STRING) AS id_tipo_calendario,
    SAFE_CAST(tud_id AS STRING) AS id_disciplina,
    SAFE_CAST(tau_recursosUtilizados AS STRING) AS recursos_utilizados
FROM `rj-sme.educacao_basica_frequencia_staging.turma_aula`