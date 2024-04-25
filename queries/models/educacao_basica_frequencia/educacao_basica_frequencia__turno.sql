{{ config(alias='turno', schema='educacao_basica_frequencia') }}

SELECT
    SAFE_CAST(REGEXP_REPLACE(TRIM(ent_id), r'\.0$', '') AS STRING) AS id_entidade,
    SAFE_CAST(REGEXP_REPLACE(TRIM(trn_controletempo), r'\.0$', '') AS INT64) AS controle_tempo,
    SAFE_CAST(SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', trn_dataalteracao) AS DATETIME) AS data_alteracao,
    SAFE_CAST(SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', trn_datacriacao) AS DATETIME) AS data_criacao,
    SAFE_CAST(TRIM(trn_descricao) AS STRING) AS descricao_turno,
    SAFE_CAST(TRIM(trn_horafim) AS TIME) AS hora_fim,
    SAFE_CAST(TRIM(trn_horainicio) AS TIME) AS hora_inicio,
    SAFE_CAST(REGEXP_REPLACE(TRIM(trn_id), r'\.0$', '') AS INT64) AS id_turno,
    SAFE_CAST(TRIM(trn_padrao) AS BOOL) AS turno_padrao,
    SAFE_CAST(REGEXP_REPLACE(TRIM(trn_situacao), r'\.0$', '') AS INT64) AS situacao,
    SAFE_CAST(REGEXP_REPLACE(TRIM(ttn_id), r'\.0$', '') AS INT64) AS id_tipo_turno,
FROM `rj-sme.educacao_basica_frequencia_staging.turno` AS t