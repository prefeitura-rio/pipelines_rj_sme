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
        "materialize_after_dump": True,
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
    "turma_aula_aluno": {
        "dataset_id": "educacao_basica_frequencia",
        "partition_columns": "taa_dataAlteracao",
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
                taa_anotacao,
                taa_frequenciaBitMap,
                usu_idDocenteAlteracao
            FROM GestaoEscolar.dbo.CLS_TurmaAulaAluno
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
