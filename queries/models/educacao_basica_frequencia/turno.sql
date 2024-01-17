SELECT
    SAFE_CAST(trn_id AS STRING) AS id_turno,
    SAFE_CAST(ent_id AS STRING) AS id_entidade,
    SAFE_CAST(trn_descricao AS STRING) AS descricao_turno,
    SAFE_CAST(trn_padrao AS BOOL) AS turno_padrao,
    SAFE_CAST(trn_situacao AS INT64) AS situacao,
    SAFE_CAST(trn_dataCriacao AS DATETIME) AS data_criacao,
    SAFE_CAST(trn_dataAlteracao AS DATETIME) AS data_alteracao,
    SAFE_CAST(trn_controleTempo AS INT64) AS controle_tempo,
    SAFE_CAST(trn_horaInicio AS TIME) AS hora_inicio,
    SAFE_CAST(trn_horaFim AS TIME) AS hora_fim,
    SAFE_CAST(ttn_id AS STRING) AS id_tipo_turno
FROM `rj-sme.educacao_basica_frequencia_staging.turno` LIMIT 1000