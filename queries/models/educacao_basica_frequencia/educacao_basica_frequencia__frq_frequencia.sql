{{ config(
    materialized='incremental',
    unique_key='surrogate_key',
    incremental_strategy='merge',
    partition_by={
        "field": "updated_at",
        "data_type": "timestamp"
    },
    alias='frequencia'
) }}

with Turmas as (
    SELECT 
        substring(esc.esc_codigo,1,2) as cre,
        tur.tur_id,
        tur.esc_id,
        tur.tur_codigo,
        tur.cal_id,
        tur.tur_tipo,
        tud.tud_id,
        tud.tud_codigo,
        tud.tud_nome,
        tud.tud_tipo,
        tud.tud_cargaHorariaSemanal,
        trn.trn_id,
        tcr.cur_id,
        fav.fav_tipoApuracaoFrequencia
    FROM {{ ref('brutos_gestao_escolar__tur_turma') }} tur
    INNER JOIN {{ ref('brutos_gestao_escolar__turma_disciplina_rel') }} rtd 
        ON rtd.tur_id = tur.tur_id AND tur_situacao = '1'
    INNER JOIN {{ ref('brutos_gestao_escolar__turma_disciplina') }} tud 
        ON tud.tud_id = rtd.tud_id AND tud_situacao = '1'
    INNER JOIN {{ ref('brutos_gestao_escolar__formato_avaliacao') }} fav 
        ON fav.fav_id = tur.fav_id AND fav_situacao <> '3'
    INNER JOIN {{ ref('brutos_gestao_escolar__turno') }} trn 
        ON tur.trn_id = trn.trn_id AND trn_situacao = '1'
    INNER JOIN {{ ref('brutos_gestao_escolar__esc_escola') }} esc 
        ON tur.esc_id = esc.esc_id AND esc_situacao = '1'
    INNER JOIN {{ ref('brutos_gestao_escolar__turma_curriculo') }} tcr 
        ON tcr.tur_id = tur.tur_id AND tcr_situacao = '1'
),

FrequenciaDia as (
    SELECT
    -- Surrogate Key
        md5(
            cast(tur.tud_id as string) || '-' ||
            cast(tau.tau_id as string) || '-' ||
            cast(taa.alu_id as string) || '-' ||
            cast(taa.mtu_id as string) || '-' ||
            cast(taa.mtd_id as string)
        ) AS surrogate_key,

        tur.cre,
        tur.tur_id,
        tur.esc_id,
        tur.tur_codigo,
        tur.cal_id,
        tur.tur_tipo,
        tur.tud_codigo,
        tur.tud_nome,
        tur.tud_tipo,
        tur.tud_cargaHorariaSemanal,
        tur.tud_id,
        tau.tau_id,
        tau.tpc_id,
        tau.tau_sequencia,
        CASE 
            WHEN fav_tipoApuracaoFrequencia = '2' THEN '1'
            ELSE tau.tau_numeroAulas 
        END AS tau_numeroAulas,
        tau.tau_situacao,
        tau.tau_efetivado,
        taa.alu_id,
        taa.mtu_id,
        taa.mtd_id,
        taa.taa_situacao,
        CASE 
            WHEN fav_tipoApuracaoFrequencia = '2' AND taa.taa_frequencia > '0' THEN '1'
            ELSE taa.taa_frequencia 
        END AS taa_frequencia,
        taa.taa_frequenciaBitMap,
        tur.trn_id,
        tur.cur_id,
        tau.tau_data AS dataAula,
        EXTRACT(YEAR FROM CAST(tau.tau_data AS DATETIME)) AS cal_ano,
        taa.taa_dataAlteracao AS updated_at
    FROM Turmas tur
    INNER JOIN {{ ref('brutos_gestao_escolar__turma_aula') }} tau 
        ON tau.tud_id = tur.tud_id
        AND EXTRACT(YEAR FROM CAST(tau.tau_data AS DATETIME)) = 2025
    INNER JOIN {{ ref('brutos_gestao_escolar__turma_aula_aluno') }} taa 
        ON taa.tud_id = tau.tud_id 
        AND taa.tau_id = tau.tau_id
        AND CAST(taa.taa_dataAlteracao AS DATETIME) >= '2025-01-01'
        {% if is_incremental() %}
            AND taa.taa_dataAlteracao > (SELECT MAX(updated_at) FROM {{ this }})
        {% endif %}
    INNER JOIN {{ ref('brutos_gestao_escolar__mtr_matricula_turma') }} mtu 
        ON mtu.mtu_id = taa.mtu_id 
        AND mtu.alu_id = taa.alu_id
        AND mtu.mtu_situacao <> '3'
)
SELECT  surrogate_key,
        SAFE_CAST(cre AS STRING) AS coordenacao_regional,
        SAFE_CAST(tur_id AS INT64) AS id_turma,
        SAFE_CAST(esc_id AS INT64) AS id_escola,
        SAFE_CAST(tur_codigo AS STRING) AS id_secundario_turma,
        SAFE_CAST(cal_id AS INT64) AS id_ano_calendario,
        SAFE_CAST(tur_tipo AS INT64) AS tipo_turma,
        SAFE_CAST(tud_codigo AS STRING) AS id_disciplina,
        SAFE_CAST(tud_nome AS STRING) AS nome_disciplina,
        SAFE_CAST(tud_tipo AS INT64) AS id_tipo_disciplina,
        SAFE_CAST(tud_cargaHorariaSemanal AS INT64) AS carga_horaria_semanal,
        SAFE_CAST(tud_id AS INT64) AS id_disciplina_turma,
        SAFE_CAST(tau_id AS INT64) AS id_aula_disciplina,
        SAFE_CAST(tpc_id AS INT64) AS id_tipo_calendario,
        SAFE_CAST(tau_sequencia AS INT64) AS sequencia_aula,
        SAFE_CAST(tau_numeroAulas AS INT64) AS numero_aula,
        -- SAFE_CAST(tau_planoAula AS STRING) AS plano_aula,
        -- SAFE_CAST(tau_diarioClasse AS STRING) AS diario_classe,
        SAFE_CAST(tau_situacao AS INT64) AS id_situacao,
        SAFE_CAST(tau_efetivado AS BOOL) AS efetivado,
        SAFE_CAST(alu_id AS INT64) AS id_aluno,
        SAFE_CAST(mtu_id AS INT64) AS id_matricula_turma,
        SAFE_CAST(mtd_id AS INT64) AS id_matricula_disciplina,
        SAFE_CAST(taa_situacao AS INT64) AS id_situacao_aula,
        SAFE_CAST(taa_frequencia AS INT64) AS faltas_disciplina_dia,
        SAFE_CAST(taa_frequenciaBitMap AS STRING) AS frequencia_tempo,
        -- SAFE_CAST(trn_descricao AS STRING) AS descricao_turno,
        -- SAFE_CAST(etapa AS STRING) AS etapa, "Etapa de ensino está null ou seja não estamos usando"
        SAFE_CAST(dataAula AS DATETIME) AS data_aula,
        SAFE_CAST(cal_ano AS INT64) AS ano_calendario,
        SAFE_CAST(trn_id AS INT64) AS id_turno,
        SAFE_CAST(cur_id AS INT64) AS id_curso,
        SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at,

FROM FrequenciaDia
