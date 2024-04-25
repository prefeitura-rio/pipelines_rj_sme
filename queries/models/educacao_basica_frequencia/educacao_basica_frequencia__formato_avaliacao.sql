{{ config(alias='formato_avaliacao', schema='educacao_basica_frequencia') }}

SELECT
    SAFE_CAST(REGEXP_REPLACE(TRIM(ent_id), r'\.0$', '') AS STRING) AS id_entidade,
    SAFE_CAST(REGEXP_REPLACE(TRIM(esa_idconceitoglobal), r'\.0$', '') AS INT64) AS conceito_global,
    SAFE_CAST(REGEXP_REPLACE(TRIM(esc_id), r'\.0$', '') AS INT64) AS id_escola,
    SAFE_CAST(TRIM(fav_dataalteracao) AS DATETIME ) AS data_altercao,
    SAFE_CAST(TRIM(fav_datacriacao) AS DATETIME ) AS data_criacao,
    SAFE_CAST(REGEXP_REPLACE(TRIM(fav_id), r'\.0$', '') AS INT64) AS id_formato_avaliacao,
    SAFE_CAST(TRIM(fav_nome) AS STRING) AS nome_avaliacao,
    SAFE_CAST(TRIM(fav_padrao) AS BOOL) AS formato_avaliacao,
    SAFE_CAST(REGEXP_REPLACE(TRIM(fav_situacao), r'\.0$', '') AS INT64) AS situacao_registro,
    SAFE_CAST(REGEXP_REPLACE(TRIM(fav_tipo), r'\.0$', '') AS INT64) AS tipo_avaliacao,
    SAFE_CAST(REGEXP_REPLACE(TRIM(fav_tipoapuracaofrequencia), r'\.0$', '') AS INT64) AS tipo_frequencia_apurada,
    SAFE_CAST(REGEXP_REPLACE(TRIM(fav_tipolancamentofrequencia), r'\.0$', '') AS INT64) AS tipo_frequencia,
    SAFE_CAST(TRIM(percentualminimofrequencia) AS DECIMAL) AS percentual_frequencia,
    SAFE_CAST(REGEXP_REPLACE(TRIM(qtdemaxdisciplinasprogressaoparcial), r'\.0$', '') AS INT64) AS maximo_progressao,
    SAFE_CAST(REGEXP_REPLACE(TRIM(tipoprogressaoparcial), r'\.0$', '') AS INT64) AS tipo_progressao,
    SAFE_CAST(REGEXP_REPLACE(TRIM(uni_id), r'\.0$', '') AS INT64) AS id_unidade_escola,
    SAFE_CAST(TRIM(valorminimoaprovacaoconceitoglobal) AS STRING) AS valor_aprovacao_global,
    SAFE_CAST(TRIM(valorminimoaprovacaopordisciplina) AS STRING) AS valor_aprovacao_disciplina,
    SAFE_CAST(TRIM(valorminimoprogressaoparcialpordisciplina) AS STRING) AS valor_progressao,
FROM `rj-sme.educacao_basica_frequencia_staging.formato_avaliacao` AS t