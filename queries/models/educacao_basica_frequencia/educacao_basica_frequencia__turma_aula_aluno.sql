{{ config(alias='turma_aula_aluno', schema='educacao_basica_frequencia', materialized='incremental',
        partition_by={
            "field": "data_particao",
            "data_type": "date",
            "granularity": "month",
        }) }}

SELECT
    SAFE_CAST(taa_frequencia AS INT64) AS faltas_disciplina_dia,
    SAFE_CAST(taa_situacao AS INT64) AS situacao,
    SAFE_CAST(taa_dataCriacao AS DATETIME) AS data_criacao,
    SAFE_CAST(taa_dataAlteracao AS DATETIME) AS data_alteracao,
    SAFE_CAST(taa_anotacao AS STRING) AS anotacao,
    SAFE_CAST(taa_frequenciaBitMap AS STRING) AS frequencia_tempo,
    SAFE_CAST(usu_idDocenteAlteracao AS STRING) AS usuario_alteracao,
    SAFE_CAST(mtd_id AS STRING) AS id_matricula_disciplina,
    SAFE_CAST(tau_id AS STRING) AS id_aula_disciplina,
    SAFE_CAST(tud_id AS STRING) AS id_disciplina_turma,
    SAFE_CAST(mtu_id AS STRING) AS id_matricula_turma,
    SAFE_CAST(alu_id AS STRING) AS id_aluno
FROM `rj-sme.educacao_basica_frequencia_staging.turma_aula_aluno`
WHERE
    SAFE_CAST(data_particao AS DATE) < CURRENT_DATE('America/Sao_Paulo')

{% if is_incremental() %}

{% set max_partition = run_query("SELECT gr FROM (SELECT IF(max(data_particao) > CURRENT_DATE('America/Sao_Paulo'), CURRENT_DATE('America/Sao_Paulo'), max(data_particao)) as gr FROM " ~ this ~ ")").columns[0].values()[0] %}

AND
    SAFE_CAST(data_particao AS DATE) > ("{{ max_partition }}")

{% endif %}