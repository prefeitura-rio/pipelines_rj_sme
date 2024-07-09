# -*- coding: utf-8 -*-
"""
Database  dumping flows for SEOP project
"""

from copy import deepcopy

from prefect.run_configs import KubernetesRun
from prefect.storage import GCS
from prefeitura_rio.pipelines_templates.dump_url.flows import dump_url_flow
from prefeitura_rio.pipelines_utils.prefect import set_default_parameters
from prefeitura_rio.pipelines_utils.state_handlers import (
    handler_initialize_sentry,
    handler_inject_bd_credentials,
)

from pipelines.constants import constants
from pipelines.educacao_basica.dump_url.schedules import gsheets_year_update_schedule

sme_gsheets_flow = deepcopy(dump_url_flow)
sme_gsheets_flow.state_handlers = [handler_inject_bd_credentials, handler_initialize_sentry]
sme_gsheets_flow.name = "SME: Educacao Basica - Ingerir CSV do Google Drive"
sme_gsheets_flow.storage = GCS(constants.GCS_FLOWS_BUCKET.value)
sme_gsheets_flow.run_config = KubernetesRun(
    image=constants.DOCKER_IMAGE.value,
    labels=[
        constants.RJ_SME_AGENT_LABEL.value,
    ],
)

sme_gsheets_default_parameters = {
    "dataset_id": "educacao_basica_alocacao",
}
sme_gsheets_flow = set_default_parameters(
    sme_gsheets_flow, default_parameters=sme_gsheets_default_parameters
)

sme_gsheets_flow.schedule = gsheets_year_update_schedule
