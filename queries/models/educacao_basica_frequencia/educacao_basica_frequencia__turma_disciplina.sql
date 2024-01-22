{{ config(alias='turma_disciplina', schema='educacao_basica_frequencia', materialized='incremental',
        partition_by={
            "field": "data_particao",
            "data_type": "date",
            "granularity": "month",
        }) }}

SELECT
    SAFE_CAST(tud_id AS STRING) AS id_disciplina_turma,
    SAFE_CAST(tud_codigo AS STRING) AS cod_disciplina,
    SAFE_CAST(tud_nome AS STRING) AS nome_disciplina,
    SAFE_CAST(tud_multiseriado AS BOOL) AS multiseriado,
    SAFE_CAST(tud_vagas AS INT64) AS numero_vagas,
    SAFE_CAST(tud_minimoMatriculados AS INT64) AS minimo_matriculados,
    SAFE_CAST(tud_duracao AS INT64) AS duracao,
    SAFE_CAST(tud_modo AS INT64) AS modo,
    SAFE_CAST(tud_tipo AS INT64) AS tipo_disciplina,
    SAFE_CAST(tud_dataInicio AS DATE) AS data_inicio,
    SAFE_CAST(tud_dataFim AS DATE) AS data_fim,
    SAFE_CAST(tud_situacao AS INT64) AS situacao,
    SAFE_CAST(tud_dataCriacao AS DATETIME) AS data_criacao,
    SAFE_CAST(tud_dataAlteracao AS DATETIME) AS data_alteracao,
    SAFE_CAST(tud_cargaHorariaSemanal AS INT64) AS carga_hora_semanal,
    SAFE_CAST(tud_aulaForaPeriodoNormal AS BOOL) AS aula_periodo,
    SAFE_CAST(tud_global AS BOOL) AS global,
    SAFE_CAST(tud_disciplinaEspecial AS BOOL) AS disciplina_especial,
    SAFE_CAST(tud_naoLancarNota AS BOOL) AS tud_naoLancarNota,
    SAFE_CAST(tud_naoLancarFrequencia AS BOOL) AS tud_naoLancarFrequencia,
    SAFE_CAST(tud_naoExibirNota AS BOOL) AS tud_naoExibirNota,
    SAFE_CAST(tud_naoExibirFrequencia AS BOOL) AS tud_naoExibirFrequencia,
    SAFE_CAST(tud_semProfessor AS BOOL) AS tud_semProfessor,
    SAFE_CAST(tud_naoExibirBoletim AS BOOL) AS tud_naoExibirBoletim
FROM `rj-sme.educacao_basica_frequencia_staging.turma_disciplina`
WHERE
    SAFE_CAST(data_particao AS DATE) < CURRENT_DATE('America/Sao_Paulo')

{% if is_incremental() %}

{% set max_partition = run_query("SELECT gr FROM (SELECT IF(max(data_particao) > CURRENT_DATE('America/Sao_Paulo'), CURRENT_DATE('America/Sao_Paulo'), max(data_particao)) as gr FROM " ~ this ~ ")").columns[0].values()[0] %}

AND
    SAFE_CAST(data_particao AS DATE) > ("{{ max_partition }}")

{% endif %}