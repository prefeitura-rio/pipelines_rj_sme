{{ config(alias='esc_escola', schema='brutos_gestao_escolar') }}

SELECT 
    SPLIT(esc_id, '.')[0] AS esc_id,
    SPLIT(ent_id, '.')[0] AS ent_id,
    SPLIT(uad_id, '.')[0] AS uad_id,
    TRIM(esc_codigo) AS esc_codigo,
    TRIM(esc_nome) AS esc_nome,
    TRIM(esc_codigoInep) AS esc_codigoInep,
    SPLIT(cid_id, '.')[0] AS cid_id,
    SPLIT(tre_id, '.')[0] AS tre_id,
    SAFE_CAST(TRIM(esc_funcionamentoInicio) AS DATETIME) AS esc_funcionamentoInicio,
    SAFE_CAST(TRIM(esc_funcionamentoFim) AS DATETIME) AS esc_funcionamentoFim,
    TRIM(esc_situacao) AS esc_situacao,
    SAFE_CAST(TRIM(esc_dataCriacao) AS DATETIME) AS esc_dataCriacao,
    SAFE_CAST(TRIM(esc_dataAlteracao) AS DATETIME) AS esc_dataAlteracao,
    SAFE_CAST(TRIM(esc_controleSistema) AS BOOL) AS esc_controleSistema,
    TRIM(esc_atoCriacao) AS esc_atoCriacao,
    SAFE_CAST(TRIM(esc_dataPublicacaoDiarioOficial) AS DATETIME) AS esc_dataPublicacaoDiarioOficial,
    TRIM(esc_codigoNumeroMatricula) AS esc_codigoNumeroMatricula,
    TRIM(esc_autorizada) AS esc_autorizada,
    SPLIT(uad_idSuperiorGestao, '.')[0] AS uad_idSuperiorGestao,
    TRIM(esc_fundoVerso) AS esc_fundoVerso,
    TRIM(esc_microareaCampo) AS esc_microareaCampo
FROM {{ source('educacao_basica_frequencia_staging', 'esc_escola') }} tur
