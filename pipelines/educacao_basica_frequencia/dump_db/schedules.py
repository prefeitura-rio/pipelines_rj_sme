# -*- coding: utf-8 -*-
"""
Schedules for the database dump pipeline....
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
        "partition_columns": "Ano",
        "partition_date_format": "%Y",
        "break_query_frequency": "year",
        "break_query_start": "current_year",
        "break_query_end": "current_year",
        "dump_mode": "append",
        "materialize_after_dump": False,
        "materialize_to_datario": False,
        "dump_to_gcs": False,
        "materialization_mode": "prod",
        "dbt_alias": True,
        "execute_query": """
            SELECT
                Ano, Curso, Nivel_Ensino,
                Modalidade, Grupamento, Turma,
                Turno, Sala, Area_Sala, Capac_Sala,
                Tipo_Sala, Sala_Util_Como, Tot_Turma,
                tur_id, esc_id, dep_id
            FROM GestaoEscolar.dbo.VW_BI_Turma
        """,
    },
    "CLS_TurmaAulaAluno": {
        "dataset_id": "educacao_basica_frequencia",
        "partition_columns": "taa_dataAlteracao_converted",
        "partition_date_format": "%Y-%m-%d",
        "break_query_frequency": "day",
        "break_query_start": "current_day",
        "break_query_end": "current_day",
        "dump_mode": "append",
        "materialize_after_dump": False,
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
                CONVERT(date, taa_dataAlteracao) AS taa_dataAlteracao_converted,
                taa_anotacao,
                taa_frequenciaBitMap,
                usu_idDocenteAlteracao,
                GETDATE() AS loaded_at
            FROM GestaoEscolar.dbo.CLS_TurmaAulaAluno
        """,
    },
    "diasCoc": {
        "materialize_after_dump": False,
        "materialize_to_datario": False,
        "dump_to_gcs": False,
        "materialization_mode": "prod",
        "dump_mode": "overwrite",
        "dbt_alias": True,
        "execute_query": """
            select distinct cal.cal_id,
                            tpc_id,
                            dbo.FN_CalcularDiasUteis(cap_dataInicio,cap_dataFim,'8BB1DECA-BB19-E011-87E8-E61F133BFC53',
                            cal.cal_id) diasCoc
            from ACA_CalendarioPeriodo cap WITH(NOLOCK)
            INNER JOIN ACA_CalendarioAnual          CAL WITH(NOLOCK) ON CAL.cal_id = cap.cal_id and cal_situacao <> 3
            inner join MTR_ProcessoFechamentoInicio pfi WITH(NOLOCK) ON pfi.pfi_anoInicio = cal.cal_ano and pfi_situacao <> 3 and pfi_AnoLetivoCorrente = 1
        """,
    },
}


sme_clocks = generate_dump_db_schedules(
    interval=timedelta(days=1),
    start_date=datetime(2022, 1, 1, 2, 10, tzinfo=pytz.timezone("America/Sao_Paulo")),
    runs_interval_minutes=2,
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
