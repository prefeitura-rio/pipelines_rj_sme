# -*- coding: utf-8 -*-
# flake8: noqa: E501
"""
Schedules for the database dump pipeline
"""

from datetime import datetime, timedelta

import pytz
from prefect.schedules import Schedule
from prefeitura_rio.pipelines_utils.io import untuple_clocks as untuple
from prefeitura_rio.pipelines_utils.prefect import gene

from pipelines.constants import constants
from pipelines.educacao_basica_avaliacao.dbt.utils import generate_dbt_schedules

#####################################
#
# Educação Básica - Avaliação, DBT Schedule
#
#####################################

table_parameters = {
    "avaliacao_bimestral_2012_a_2019": {
        "table_id": "avaliacao_bimestral_2012_a_2019",
        "dataset_id": "educacao_basica_avaliacao",
        "dbt_model_secret_parameters": [{"secret_name": "HASH_SEED", "secret_path": "/dbt-vars"}],
    },
    "avaliacao_bimestral_2021_a_2024": {
        "table_id": "avaliacao_bimestral_2021_a_2024",
        "dataset_id": "educacao_basica_avaliacao",
        "dbt_model_secret_parameters": [{"secret_name": "HASH_SEED", "secret_path": "/dbt-vars"}],
    },
}

educacao_basica_avaliacao_clocks = generate_dbt_schedules(
    interval=timedelta(days=365),
    runs_interval_minutes=1,
    start_date=datetime(2023, 3, 28, 17, 30, tzinfo=pytz.timezone("America/Sao_Paulo")),
    labels=[
        constants.RJ_SME_AGENT_LABEL.value,
    ],
    table_parameters=table_parameters,
)

educacao_basica_avaliacao_update_schedule = Schedule(
    clocks=untuple(educacao_basica_avaliacao_clocks)
)
