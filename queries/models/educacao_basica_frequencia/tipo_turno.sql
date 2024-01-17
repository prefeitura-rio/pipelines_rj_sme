SELECT
    SAFE_CAST(ttn_id AS STRING) AS id_tipo_turno,
    SAFE_CAST(ttn_nome AS STRING) AS tipo_turno,
    SAFE_CAST(ttn_situacao AS INT64) AS situacao,
    SAFE_CAST(ttn_dataCriacao AS DATETIME) AS data_criacao,
    SAFE_CAST(ttn_dataAlteracao AS DATETIME) AS data_alteracao,
    SAFE_CAST(ttn_tipo AS INT64) AS ttn_tipo,
    SAFE_CAST(ttn_classificacao AS INT64) AS ttn_classificacao
FROM `rj-sme.educacao_basica_frequencia_staging.tipo_turno`