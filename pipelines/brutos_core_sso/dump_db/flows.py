# -*- coding: utf-8 -*-
"""
Database dumping flows for SME project.......
"""

from copy import deepcopy

from prefect.run_configs import KubernetesRun
from prefect.storage import GCS
from prefeitura_rio.pipelines_templates.dump_db.flows import flow as dump_sql_flow
from prefeitura_rio.pipelines_utils.prefect import set_default_parameters
from prefeitura_rio.pipelines_utils.state_handlers import (
    handler_initialize_sentry,
    handler_inject_bd_credentials,
)

from pipelines.brutos_core_sso.dump_db.schedules import (
    sme_brutos_core_sso_daily_update_schedule,
)
from pipelines.constants import constants

dump_sme_core_sso_flow = deepcopy(dump_sql_flow)
dump_sme_core_sso_flow.state_handlers = [handler_inject_bd_credentials, handler_initialize_sentry]
dump_sme_core_sso_flow.name = "SME: brutos_core_sso - Ingerir tabelas de banco SQL"
dump_sme_core_sso_flow.storage = GCS(constants.GCS_FLOWS_BUCKET.value)

dump_sme_core_sso_flow.run_config = KubernetesRun(
    image=constants.DOCKER_IMAGE.value,
    labels=[
        constants.RJ_SME_AGENT_LABEL.value,
    ],
)

sme_default_parameters = {
    "db_database": "CoreSSO",
    "db_host": "10.70.6.103",
    "db_port": "1433",
    "db_type": "sql_server",
    "infisical_secret_path": "/db-educacao-basica",
    "dataset_id": "brutos_core_sso",
}
dump_sme_core_sso_flow = set_default_parameters(
    dump_sme_core_sso_flow, default_parameters=sme_default_parameters
)

dump_sme_core_sso_flow.schedule = sme_brutos_core_sso_daily_update_schedule

# Comment to trigger.
