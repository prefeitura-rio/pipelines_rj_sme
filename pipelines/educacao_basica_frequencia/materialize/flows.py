# -*- coding: utf-8 -*-
"""
Database dumping flows for SME project.........
"""

from copy import deepcopy

from prefect.run_configs import KubernetesRun
from prefect.storage import GCS
from prefeitura_rio.pipelines_templates.run_dbt_model.flows import (
    templates__run_dbt_model__flow,
)
from prefeitura_rio.pipelines_utils.prefect import set_default_parameters
from prefeitura_rio.pipelines_utils.state_handlers import (
    handler_initialize_sentry,
    handler_inject_bd_credentials,
)

from pipelines.constants import constants
from pipelines.educacao_basica_frequencia.materialize.schedules import (
    sme_educacao_basica_frequencia_daily_update_schedule,
)

materialize_sme_frequencia_flow = deepcopy(templates__run_dbt_model__flow)
materialize_sme_frequencia_flow.state_handlers = [handler_inject_bd_credentials, handler_initialize_sentry]
materialize_sme_frequencia_flow.name = "SME: educacao_basica_frequencia - Materializar tabelas"
materialize_sme_frequencia_flow.storage = GCS(constants.GCS_FLOWS_BUCKET.value)

materialize_sme_frequencia_flow.run_config = KubernetesRun(
    image=constants.DOCKER_IMAGE.value,
    labels=[
        constants.RJ_SME_AGENT_LABEL.value,
    ],
)

sme_default_parameters = {
    "dataset_id": "educacao_basica_frequencia",
    "upstream": True,
    "materialize_to_datario": False,
}
materialize_sme_frequencia_flow = set_default_parameters(
    materialize_sme_frequencia_flow, default_parameters=sme_default_parameters
)

materialize_sme_frequencia_flow.schedule = sme_educacao_basica_frequencia_daily_update_schedule
