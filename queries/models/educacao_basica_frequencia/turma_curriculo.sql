SELECT
    SAFE_CAST(tcr_prioridade AS INT64) AS prioridade_curriculo,
    SAFE_CAST(tcr_situacao AS INT64) AS situacao,
    SAFE_CAST(tcr_dataCriacao AS DATETIME) AS data_criacao,
    SAFE_CAST(tcr_dataAlteracao AS DATETIME) AS data_alteracao,
    SAFE_CAST(crp_id AS STRING) AS id_periodo_curriculo,
    SAFE_CAST(crr_id AS STRING) AS id_curriculo,
    SAFE_CAST(cur_id AS STRING) AS id_curso,
    SAFE_CAST(tur_id AS STRING) AS id_turma
FROM `rj-sme.educacao_basica_frequencia_staging.turma_curriculo`