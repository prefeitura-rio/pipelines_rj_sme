{{ config(alias='frequencia'}}

SELECT  SAFE_CAST(frq_id AS INT64) AS frq_id,
        SAFE_CAST(cre AS STRING) AS cre,
        SAFE_CAST(tur_id AS INT64) AS tur_id,
        SAFE_CAST(esc_id AS INT64) AS esc_id,
        SAFE_CAST(tur_codigo AS STRING) AS tur_codigo,
        SAFE_CAST(cal_id AS INT64) AS cal_id,
        SAFE_CAST(tur_tipo AS INT64) AS tur_tipo,
        SAFE_CAST(tud_codigo AS STRING) AS tud_codigo,
        SAFE_CAST(tud_nome AS STRING) AS tud_nome,
        SAFE_CAST(tud_tipo AS INT64) AS tud_tipo,
        SAFE_CAST(tud_cargaHorariaSemanal AS INT64) AS tud_cargaHorariaSemanal,
        SAFE_CAST(tud_id AS INT64) AS tud_id,
        SAFE_CAST(tau_id AS INT64) AS tau_id,
        SAFE_CAST(tpc_id AS INT64) AS tpc_id,
        SAFE_CAST(tau_sequencia AS INT64) AS tau_sequencia,
        SAFE_CAST(tau_numeroAulas AS INT64) AS tau_numeroAulas,
        SAFE_CAST(tau_planoAula AS STRING) AS tau_planoAula,
        SAFE_CAST(tau_diarioClasse AS STRING) AS tau_diarioClasse,
        SAFE_CAST(tau_situacao AS INT64) AS tau_situacao,
        SAFE_CAST(tau_efetivado AS BOOL) AS tau_efetivado,
        SAFE_CAST(alu_id AS INT64) AS alu_id,
        SAFE_CAST(mtu_id AS INT64) AS mtu_id,
        SAFE_CAST(mtd_id AS INT64) AS mtd_id,
        SAFE_CAST(taa_situacao AS INT64) AS taa_situacao,
        SAFE_CAST(taa_frequencia AS INT64) AS taa_frequencia,
        SAFE_CAST(taa_frequenciaBitMap AS STRING) AS taa_frequenciaBitMap,
        SAFE_CAST(trn_descricao AS STRING) AS trn_descricao,
        -- SAFE_CAST(etapa AS STRING) AS etapa, "Etapa de ensino está null ou seja não estamos usando"
        SAFE_CAST(dataAula AS DATETIME) AS dataAula,
        SAFE_CAST(cal_ano AS INT64) AS cal_ano,
        SAFE_CAST(trn_id AS INT64) AS trn_id,
        SAFE_CAST(cur_id AS INT64) AS cur_id
from {{ source('educacao_basica_frequencia_staging', 'FRQ_FREQUENCIA')}}