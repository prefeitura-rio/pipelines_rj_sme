# -*- coding: utf-8 -*-
"""
Schedules for the database materialize pipeline....
"""

from datetime import datetime, timedelta

import pytz
from prefect.schedules import Schedule
from prefect.schedules.clocks import IntervalClock
from prefeitura_rio.pipelines_utils.io import untuple_clocks as untuple

from pipelines.constants import constants

#####################################
#
# SME Schedules
#
#####################################

sme_frequencia_tables = {
    "educacao_basica_frequencia__frequencia": "educacao_basica_frequencia__frequencia",
}


sme_clocks = [
    IntervalClock(
        interval=timedelta(days=1),
        start_date=datetime(2021, 11, 23, 14, 0, tzinfo=pytz.timezone("America/Sao_Paulo"))
        + timedelta(minutes=3 * count),
        labels=[
            constants.RJ_SME_AGENT_LABEL.value,
        ],
        parameter_defaults={
            "dataset_id": "educacao_basica_frequencia",
            "table_id": table_id,
            "mode": "prod",
        },
    )
    for count, (_, table_id) in enumerate(sme_frequencia_tables.items())
]
sme_educacao_basica_frequencia_daily_update_schedule = Schedule(clocks=untuple(sme_clocks))
