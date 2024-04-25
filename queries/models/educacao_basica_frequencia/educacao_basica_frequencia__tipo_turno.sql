{{ config(alias='tipo_turno', schema='educacao_basica_frequencia') }}

SELECT
    SAFE_CAST(TRIM(ttn_dataalteracao) AS DATETIME ) AS data_alteracao,
    SAFE_CAST(TRIM(ttn_datacriacao) AS DATETIME ) AS data_criacao,
    SAFE_CAST(REGEXP_REPLACE(TRIM(ttn_id), r'\.0$', '') AS STRING) AS id_tipo_turno,
    SAFE_CAST(TRIM(ttn_nome) AS STRING) AS tipo_turno,
    SAFE_CAST(REGEXP_REPLACE(TRIM(ttn_situacao), r'\.0$', '') AS STRING) AS id_situacao,
FROM `rj-sme.educacao_basica_frequencia_staging.tipo_turno` AS t