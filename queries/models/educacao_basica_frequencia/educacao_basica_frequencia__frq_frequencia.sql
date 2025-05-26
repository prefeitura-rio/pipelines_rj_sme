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
            tud.id_disciplina_turma,
            tud.id_disciplina,
            tud.nome_disciplina,
            tud.id_tipo,
            tud.carga_hora_semanal,
            trn.id_turno,
            tcr.id_curso,
            fav.tipo_frequencia_apurada
        FROM {{ ref('brutos_gestao_escolar__tur_turma') }} tur
        INNER JOIN {{ ref('brutos_gestao_escolar__turma_disciplina_rel') }} rtd
            ON rtd.id_turma = tur.tur_id AND tur_situacao = 1
        INNER JOIN {{ ref('brutos_gestao_escolar__turma_disciplina') }} tud
            ON tud.id_disciplina_turma = rtd.id_disciplina AND id_situacao = '1'
        INNER JOIN {{ ref('brutos_gestao_escolar__formato_avaliacao') }} fav
            ON fav.id_formato_avaliacao = tur.fav_id AND situacao_registro <> 3
        INNER JOIN {{ ref('brutos_gestao_escolar__turno') }} trn
            ON tur.trn_id = trn.id_turno AND situacao = 1
        INNER JOIN {{ ref('brutos_gestao_escolar__esc_escola') }} esc
            ON tur.esc_id = esc.id_esc AND esc_situacao = 1
        INNER JOIN {{ ref('brutos_gestao_escolar__turma_curriculo') }} tcr
            ON tcr.id_turma = tur.tur_id AND tcr.id_situacao = '1'
    ),
    {% if is_incremental() %}
    max_data_alteracao as (
        SELECT MAX(updated_at) AS ultima_data_alteracao
        FROM {{ this }}
    ),
    {% endif %}
    FrequenciaDia as (
        SELECT
        -- Surrogate Key
            md5(
                cast(tur.id_disciplina_turma as string) || '-' ||
                cast(tau.id_aula_disciplina as string) || '-' ||
                cast(taa.id_aluno as string) || '-' ||
                cast(taa.id_matricula_turma as string) || '-' ||
                cast(taa.id_matricula_disciplina as string)
            ) AS surrogate_key,

            tur.cre,
            tur.tur_id,
            tur.esc_id,
            tur.tur_codigo,
            tur.cal_id,
            tur.tur_tipo,
            tur.id_disciplina,
            tur.nome_disciplina,
            tur.id_tipo,
            tur.carga_hora_semanal,
            tur.id_disciplina_turma,
            tau.id_aula_disciplina,
            tau.id_tipo_calendario,
            tau.sequencia_aula,
            CASE
                WHEN tipo_frequencia_apurada = 2 THEN 1
                ELSE tau.numero_aula
            END AS tau_numeroAulas,
            tau.id_situacao AS id_situacao,
            tau.efetivado,
            taa.id_aluno,
            taa.id_matricula_turma,
            taa.id_matricula_disciplina,
            taa.id_situacao AS id_situacao_aula,
            CASE
                WHEN tipo_frequencia_apurada = 2 AND taa.faltas_disciplina_dia > '0' THEN '1'
                ELSE taa.faltas_disciplina_dia
            END AS taa_frequencia,
            taa.frequencia_tempo,
            tur.id_turno,
            tur.id_curso,
            tau.data_aula AS dataAula,
            EXTRACT(YEAR FROM tau.data_aula) AS cal_ano,
            taa.data_alteracao AS updated_at
        FROM Turmas tur
        {% if is_incremental() %}
        INNER JOIN max_data_alteracao ultima_data_alteracao ON TRUE
        {% endif %}
        INNER JOIN {{ ref('brutos_gestao_escolar__turma_aula') }} tau
            ON tau.id_disciplina = tur.id_disciplina_turma
            AND EXTRACT(YEAR FROM tau.data_aula) = 2025
        INNER JOIN {{ ref('brutos_gestao_escolar__turma_aula_aluno') }} taa
            ON taa.id_disciplina_turma = tau.id_disciplina
            AND taa.id_aula_disciplina = CAST(tau.id_aula_disciplina AS STRING)
            AND CAST(taa.data_alteracao AS DATETIME) >= '2025-01-01'
            {% if is_incremental() %}
                AND taa.data_alteracao > ultima_data_alteracao.ultima_data_alteracao
            {% endif %}
        INNER JOIN {{ ref('brutos_gestao_escolar__mtr_matricula_turma') }} mtu
            ON CAST(mtu.mtu_id AS STRING) = taa.id_matricula_turma
            AND CAST(mtu.alu_id AS STRING) = taa.id_aluno
            AND mtu.mtu_situacao <> 3

    )
    SELECT  surrogate_key,
            SAFE_CAST(cre AS STRING) AS coordenacao_regional,
            SAFE_CAST(tur_id AS INT64) AS id_turma,
            SAFE_CAST(esc_id AS INT64) AS id_escola,
            SAFE_CAST(tur_codigo AS STRING) AS id_secundario_turma,
            SAFE_CAST(cal_id AS INT64) AS id_ano_calendario,
            SAFE_CAST(tur_tipo AS INT64) AS tipo_turma,
            SAFE_CAST(id_disciplina AS STRING) AS id_disciplina,
            SAFE_CAST(nome_disciplina AS STRING) AS nome_disciplina,
            SAFE_CAST(id_tipo AS INT64) AS id_tipo_disciplina,
            SAFE_CAST(carga_hora_semanal AS INT64) AS carga_horaria_semanal,
            SAFE_CAST(id_disciplina_turma AS INT64) AS id_disciplina_turma,
            SAFE_CAST(id_aula_disciplina AS INT64) AS id_aula_disciplina,
            SAFE_CAST(id_tipo_calendario AS INT64) AS id_tipo_calendario,
            SAFE_CAST(id_tipo_calendario AS INT64) AS sequencia_aula,
            SAFE_CAST(tau_numeroAulas AS INT64) AS numero_aula,
            -- SAFE_CAST(tau_planoAula AS STRING) AS plano_aula,
            -- SAFE_CAST(tau_diarioClasse AS STRING) AS diario_classe,
            SAFE_CAST(id_situacao AS INT64) AS id_situacao,
            SAFE_CAST(efetivado AS BOOL) AS efetivado,
            SAFE_CAST(id_aluno AS INT64) AS id_aluno,
            SAFE_CAST(id_matricula_turma AS INT64) AS id_matricula_turma,
            SAFE_CAST(id_matricula_disciplina AS INT64) AS id_matricula_disciplina,
            SAFE_CAST(id_situacao_aula AS INT64) AS id_situacao_aula,
            SAFE_CAST(taa_frequencia AS INT64) AS faltas_disciplina_dia,
            SAFE_CAST(frequencia_tempo AS STRING) AS frequencia_tempo,
            -- SAFE_CAST(trn_descricao AS STRING) AS descricao_turno,
            -- SAFE_CAST(etapa AS STRING) AS etapa, "Etapa de ensino está null ou seja não estamos usando"
            SAFE_CAST(dataAula AS DATETIME) AS data_aula,
            SAFE_CAST(cal_ano AS INT64) AS ano_calendario,
            SAFE_CAST(id_turno AS INT64) AS id_turno,
            SAFE_CAST(id_curso AS INT64) AS id_curso,
            SAFE_CAST(updated_at AS TIMESTAMP) AS updated_at,

    FROM FrequenciaDia
