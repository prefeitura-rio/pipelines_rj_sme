{{ config(alias='curriculo_periodo', schema='educacao_basica_frequencia') }}

SELECT
    SAFE_CAST(REGEXP_REPLACE(TRIM(crp_controletempo), r'\.0$', '') AS INT64) AS controle_tempo,
    SAFE_CAST(TRIM(crp_dataalteracao) AS DATETIME ) AS data_alteracao,
    SAFE_CAST(TRIM(crp_datacriacao) AS DATETIME ) AS data_criacao,
    SAFE_CAST(TRIM(crp_descricao) AS STRING) AS descricao_periodo,
    SAFE_CAST(REGEXP_REPLACE(TRIM(crp_id), r'\.0$', '') AS STRING) AS id_periodo_curriculo,
    SAFE_CAST(REGEXP_REPLACE(TRIM(crp_idadeidealanofim), r'\.0$', '') AS INT64) AS ano_idade_final,
    SAFE_CAST(REGEXP_REPLACE(TRIM(crp_idadeidealanoinicio), r'\.0$', '') AS INT64) AS ano_idade_inicio,
    SAFE_CAST(REGEXP_REPLACE(TRIM(crp_idadeidealmesfim), r'\.0$', '') AS INT64) AS mes_idade_final,
    SAFE_CAST(REGEXP_REPLACE(TRIM(crp_idadeidealmesinicio), r'\.0$', '') AS INT64) AS mes_idade_inicio,
    SAFE_CAST(REGEXP_REPLACE(TRIM(crp_ordem), r'\.0$', '') AS INT64) AS ordem_periodo,
    SAFE_CAST(REGEXP_REPLACE(TRIM(crp_qtdediassemana), r'\.0$', '') AS INT64) AS aulas_semana,
    SAFE_CAST(REGEXP_REPLACE(TRIM(crp_qtdehorasdia), r'\.0$', '') AS INT64) AS horas_dia,
    SAFE_CAST(REGEXP_REPLACE(TRIM(crp_qtdeminutosdia), r'\.0$', '') AS INT64) AS minutos_dia,
    SAFE_CAST(REGEXP_REPLACE(TRIM(crp_qtdetempossemana), r'\.0$', '') AS INT64) AS tempos_semana,
    SAFE_CAST(REGEXP_REPLACE(TRIM(crp_situacao), r'\.0$', '') AS STRING) AS id_situacao,
    SAFE_CAST(REGEXP_REPLACE(TRIM(crr_id), r'\.0$', '') AS STRING) AS id_curriculo,
    SAFE_CAST(REGEXP_REPLACE(TRIM(cur_id), r'\.0$', '') AS INT64) AS id_curso,
    SAFE_CAST(REGEXP_REPLACE(TRIM(mep_id), r'\.0$', '') AS STRING) AS id_etapa_mec_inep,
    SAFE_CAST(REGEXP_REPLACE(TRIM(tcp_id), r'\.0$', '') AS STRING) AS id_coc,
FROM `rj-sme.educacao_basica_frequencia_staging.curriculo_periodo` AS t