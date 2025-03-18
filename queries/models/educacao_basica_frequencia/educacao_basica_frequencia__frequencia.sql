{{ config(alias='frequencia') }}


SELECT  SAFE_CAST(frq_id AS INT64) AS id_frequencia,
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
        SAFE_CAST(tau_planoAula AS STRING) AS plano_aula,
        SAFE_CAST(tau_diarioClasse AS STRING) AS diario_classe,
        SAFE_CAST(tau_situacao AS INT64) AS id_situacao,
        SAFE_CAST(tau_efetivado AS BOOL) AS efetivado,
        SAFE_CAST(alu_id AS INT64) AS id_aluno,
        SAFE_CAST(mtu_id AS INT64) AS id_matricula_turma,
        SAFE_CAST(mtd_id AS INT64) AS id_matricula_disciplina,
        SAFE_CAST(taa_situacao AS INT64) AS id_situacao_aula,
        SAFE_CAST(taa_frequencia AS INT64) AS faltas_disciplina_dia,
        SAFE_CAST(taa_frequenciaBitMap AS STRING) AS frequencia_tempo,
        SAFE_CAST(trn_descricao AS STRING) AS descricao_turno ,
        -- SAFE_CAST(etapa AS STRING) AS etapa, "Etapa de ensino está null ou seja não estamos usando"
        SAFE_CAST(dataAula AS DATETIME) AS data_aula,
        SAFE_CAST(cal_ano AS INT64) AS ano_calendario,
        SAFE_CAST(trn_id AS INT64) AS id_turno,
        SAFE_CAST(cur_id AS INT64) AS id_curso
from {{ source('educacao_basica_frequencia_staging', 'FRQ_FREQUENCIA')}}