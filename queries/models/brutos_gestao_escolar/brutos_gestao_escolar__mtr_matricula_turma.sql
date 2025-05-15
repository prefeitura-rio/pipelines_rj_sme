{{ config(alias='mtr_matricula_turma', schema='brutos_gestao_escolar') }}

SELECT
    SPLIT(alu_id, '.')[0] AS alu_id,
    SPLIT(mtu_id, '.')[0] AS mtu_id,
    SPLIT(tur_id, '.')[0] AS tur_id,
    SPLIT(cur_id, '.')[0] AS cur_id,
    SPLIT(crr_id, '.')[0] AS crr_id,
    SPLIT(crp_id, '.')[0] AS crp_id,
    CAST(TRIM(mtu_dataMatricula) AS DATETIME) AS mtu_dataMatricula,
    TRIM(mtu_avaliacao) AS mtu_avaliacao,
    TRIM(mtu_frequencia) AS mtu_frequencia,
    TRIM(mtu_relatorio) AS mtu_relatorio,
    TRIM(mtu_resultado) AS mtu_resultado,
    CAST(TRIM(mtu_dataSaida) AS DATETIME) AS mtu_dataSaida,
    TRIM(mtu_situacao) AS mtu_situacao,
    CAST(TRIM(mtu_dataCriacao) AS DATETIME) AS mtu_dataCriacao,
    CAST(TRIM(mtu_dataAlteracao) AS DATETIME) AS mtu_dataAlteracao,
    TRIM(mtu_numeroChamada) AS mtu_numeroChamada,
    SPLIT(alc_id, '.')[0] AS alc_id,
    SPLIT(usu_idResultado, '.')[0] AS usu_idResultado
FROM {{ source('educacao_basica_frequencia_staging', 'mtr_matricula_turma') }} tur
