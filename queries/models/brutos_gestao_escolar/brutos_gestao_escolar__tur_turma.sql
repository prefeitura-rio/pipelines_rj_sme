{{ config(alias='tur_turma', schema='brutos_gestao_escolar') }}

SELECT
    SPLIT(tur_id, ".")[0] as tur_id,
    SPLIT(esc_id, ".")[0] as esc_id,
    SPLIT(uni_id, ".")[0] as uni_id,
    TRIM(tur_codigo) as tur_codigo,
    TRIM(tur_descricao) as tur_descricao,
    SPLIT(tur_vagas, ".")[0] as tur_vagas,
    SPLIT(tur_minimoMatriculados, ".")[0] as tur_minimoMatriculados,
    TRIM(tur_duracao) as tur_duracao,
    SPLIT(cal_id, ".")[0] as cal_id,
    SPLIT(trn_id, ".")[0] as trn_id,
    TRIM(tur_situacao) as tur_situacao,
    SAFE_CAST(TRIM(tur_dataCriacao) AS DATETIME) as tur_dataCriacao,
    SAFE_CAST(TRIM(tur_dataAlteracao) AS DATETIME) as tur_dataAlteracao,
    SPLIT(fav_id, ".")[0] as fav_id,
    SAFE_CAST(TRIM(tur_docenteEspecialista) AS BOOLEAN) as tur_docenteEspecialista,
    TRIM(tur_tipo) as tur_tipo,
    SAFE_CAST(TRIM(tur_participaRodizio) AS BOOLEAN) as tur_participaRodizio,
    SPLIT(prd_id, ".")[0] as prd_id,
    SPLIT(dep_id, ".")[0] as dep_id,
    TRIM(tur_observacao) as tur_observacao,
    TRIM(tur_codigoInep) as tur_codigoInep,
	SAFE_CAST(TRIM(tur_dataEncerramento) AS DATETIME) as tur_dataEncerramento,
    SAFE_CAST(TRIM(tur_seqChamada) AS BOOLEAN) as tur_seqChamada,
    SAFE_CAST(TRIM(tur_flag_tem_acrescimo) AS BOOLEAN) as tur_flag_tem_acrescimo
FROM {{ source('brutos_gestao_escolar_staging', 'TUR_Turma') }} tur
