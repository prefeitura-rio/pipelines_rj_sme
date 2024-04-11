# -*- coding: utf-8 -*-
"""
Schedules for the database dump pipeline
"""

from datetime import datetime, timedelta

import pytz
from prefect.schedules import Schedule
from prefeitura_rio.pipelines_utils.io import untuple_clocks as untuple
from prefeitura_rio.pipelines_utils.prefect import generate_dump_db_schedules

from pipelines.constants import constants

#####################################
#
# SME Schedules
#
#####################################

sme_frequencia_queries = {
    "turma": {
        "dataset_id": "educacao_basica_frequencia",
        "dump_mode": "overwrite",
        "materialize_after_dump": True,
        "materialize_to_datario": False,
        "dump_to_gcs": False,
        "materialization_mode": "prod",
        "dbt_alias": True,
        "execute_query": "SELECT * FROM GestaoEscolar.dbo.VW_BI_Turma",
    },
    "turno": {
        "dataset_id": "educacao_basica_frequencia",
        "dump_mode": "overwrite",
        "materialize_after_dump": True,
        "materialize_to_datario": False,
        "dump_to_gcs": False,
        "materialization_mode": "prod",
        "dbt_alias": True,
        "execute_query": """
            SELECT
                trn_id,
                ent_id,
                ttn_id,
                trn_descricao,
                trn_padrao,
                trn_situacao,
                trn_dataCriacao,
                trn_dataAlteracao,
                trn_controleTempo,
                trn_horaInicio,
                trn_horaFim
            FROM GestaoEscolar.dbo.ACA_Turno
        """,
    },
    "curriculo_periodo": {
        "dataset_id": "educacao_basica_frequencia",
        "dump_mode": "overwrite",
        "materialize_after_dump": True,
        "materialize_to_datario": False,
        "dump_to_gcs": False,
        "materialization_mode": "prod",
        "dbt_alias": True,
        "execute_query": """
            SELECT
                cur_id,
                crr_id,
                crp_id,
                mep_id,
                crp_ordem,
                crp_descricao,
                crp_idadeIdealAnoInicio,
                crp_idadeIdealMesInicio,
                crp_idadeIdealAnoFim,
                crp_idadeIdealMesFim,
                crp_situacao,
                crp_dataCriacao,
                crp_dataAlteracao,
                crp_controleTempo,
                crp_qtdeDiasSemana,
                crp_qtdeTemposSemana,
                crp_qtdeHorasDia,
                crp_qtdeMinutosDia,
                crp_qtdeEletivasAlunos,
                crp_ciclo,
                crp_turmaAvaliacao,
                crp_nomeAvaliacao,
                crp_qtdeTemposDia,
                crp_concluiNivelEnsino,
                tci_id,
                crp_fundoFrente,
                tcp_id,
                clg_id
            FROM GestaoEscolar.dbo.ACA_CurriculoPeriodo
        """,
    },
    "tipo_turno": {
        "dataset_id": "educacao_basica_frequencia",
        "dump_mode": "overwrite",
        "materialize_after_dump": True,
        "materialize_to_datario": False,
        "dump_to_gcs": False,
        "dbt_alias": True,
        "materialization_mode": "prod",
        "execute_query": """
            SELECT
                ttn_id,
                ttn_nome,
                ttn_situacao,
                ttn_dataCriacao,
                ttn_dataAlteracao,
                ttn_tipo,
                ttn_classificacao
            FROM GestaoEscolar.dbo.ACA_TipoTurno
        """,
    },
    "turma_disciplina_rel": {
        "dataset_id": "educacao_basica_frequencia",
        "dump_mode": "overwrite",
        "materialize_after_dump": True,
        "materialize_to_datario": False,
        "dump_to_gcs": False,
        "materialization_mode": "prod",
        "dbt_alias": True,
        "execute_query": """
            SELECT
                tur_id,
                tud_id
            FROM GestaoEscolar.dbo.TUR_TurmaRelTurmaDisciplina
        """,
    },
    "turma_curriculo": {
        "dataset_id": "educacao_basica_frequencia",
        "dump_mode": "overwrite",
        "materialize_after_dump": True,
        "materialize_to_datario": False,
        "dump_to_gcs": False,
        "materialization_mode": "prod",
        "dbt_alias": True,
        "execute_query": """
            SELECT
                tur_id,
                cur_id,
                crr_id,
                crp_id,
                tcr_prioridade,
                tcr_situacao,
                tcr_dataCriacao,
                tcr_dataAlteracao
            FROM GestaoEscolar.dbo.TUR_TurmaCurriculo
        """,
    },
    "turma_aula": {
        "dataset_id": "educacao_basica_frequencia",
        "partition_columns": "tau_dataAlteracao",
        "partition_date_format": "%Y-%m-%d",
        "lower_bound_date": "current_month",
        "dump_mode": "overwrite",
        "materialize_after_dump": True,
        "materialize_to_datario": False,
        "dump_to_gcs": False,
        "materialization_mode": "prod",
        "dbt_alias": True,
        "execute_query": """
            SELECT
                tud_id,
                tau_id,
                tpc_id,
                tau_sequencia,
                tau_data,
                tau_numeroAulas,
                tau_planoAula,
                tau_diarioClasse,
                tau_situacao,
                tau_dataCriacao,
                tau_dataAlteracao,
                tau_conteudo,
                tau_efetivado,
                tau_atividadeCasa,
                tdt_posicao,
                pro_id,
                tau_sintese,
                tau_reposicao,
                usu_id,
                usu_idDocenteAlteracao,
                tau_statusFrequencia,
                tau_statusAtividadeAvaliativa,
                tau_statusAnotacoes,
                tau_statusPlanoAula,
                tau_recursosUtilizados
            FROM GestaoEscolar.dbo.CLS_TurmaAula
        """,
    },
    "turma_aula_aluno": {
        "dataset_id": "educacao_basica_frequencia",
        "partition_columns": "taa_dataAlteracao",
        "partition_date_format": "%Y-%m-%d",
        "lower_bound_date": "current_month",
        "dump_mode": "overwrite",
        "materialize_after_dump": True,
        "materialize_to_datario": False,
        "dump_to_gcs": False,
        "materialization_mode": "prod",
        "dbt_alias": True,
        "execute_query": """
            SELECT
                tud_id,
                tau_id,
                alu_id,
                mtu_id,
                mtd_id,
                taa_frequencia,
                taa_situacao,
                taa_dataCriacao,
                taa_dataAlteracao,
                taa_anotacao,
                taa_frequenciaBitMap,
                usu_idDocenteAlteracao
            FROM GestaoEscolar.dbo.CLS_TurmaAulaAluno
        """,
    },
    "turma_disciplina": {
        "dataset_id": "educacao_basica_frequencia",
        "partition_columns": "tud_dataAlteracao",
        "partition_date_format": "%Y-%m-%d",
        "lower_bound_date": "current_month",
        "dump_mode": "overwrite",
        "materialize_after_dump": True,
        "materialize_to_datario": False,
        "dump_to_gcs": False,
        "materialization_mode": "prod",
        "dbt_alias": True,
        "execute_query": """
            SELECT
                tud_id,
                tud_codigo,
                tud_nome,
                tud_multiseriado,
                tud_vagas,
                tud_minimoMatriculados,
                tud_duracao,
                tud_modo,
                tud_tipo,
                tud_dataInicio,
                tud_dataFim,
                tud_situacao,
                tud_dataCriacao,
                tud_dataAlteracao,
                tud_cargaHorariaSemanal,
                tud_aulaForaPeriodoNormal,
                tud_global,
                tud_disciplinaEspecial,
                tud_naoLancarNota,
                tud_naoLancarFrequencia,
                tud_naoExibirNota,
                tud_naoExibirFrequencia,
                tud_semProfessor,
                tud_naoExibirBoletim
            FROM GestaoEscolar.dbo.TUR_TurmaDisciplina
        """,
    },
}


sme_clocks = generate_dump_db_schedules(
    interval=timedelta(days=1),
    start_date=datetime(2022, 1, 1, 2, 10, tzinfo=pytz.timezone("America/Sao_Paulo")),
    labels=[
        constants.RJ_SME_AGENT_LABEL.value,
    ],
    db_database="GestaoEscolar",
    db_host="10.70.6.103",
    db_port="1433",
    db_type="sql_server",
    dataset_id="educacao_basica_frequencia",
    infisical_secret_path="/db-educacao-basica",
    table_parameters=sme_frequencia_queries,
)

sme_educacao_basica_frequencia_daily_update_schedule = Schedule(clocks=untuple(sme_clocks))
