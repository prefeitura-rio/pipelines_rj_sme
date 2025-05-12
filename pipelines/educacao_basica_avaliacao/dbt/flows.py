# -*- coding: utf-8 -*-
"""
MATERIALIZA MODELOS DO DBT
"""

from copy import deepcopy

from prefect.run_configs import KubernetesRun
from prefect.storage import GCS
from prefeitura_rio.pipelines_templates.run_dbt_model.flows import (
    templates__run_dbt_model__flow,
)
from prefeitura_rio.pipelines_utils.prefect import set_default_parameters
from prefeitura_rio.pipelines_utils.state_handlers import handler_inject_bd_credentials

from pipelines.constants import constants
from pipelines.educacao_basica_avaliacao.dbt.schedules import (
    educacao_basica_avaliacao_update_schedule,
)

sme_educacao_basica_avaliacao_dbt = deepcopy(templates__run_dbt_model__flow)
sme_educacao_basica_avaliacao_dbt.name = "SME: educacao_basica_avaliacao - Materializar tabelas"
sme_educacao_basica_avaliacao_dbt.state_handlers = [handler_inject_bd_credentials]

sme_educacao_basica_avaliacao_dbt.storage = GCS(constants.GCS_FLOWS_BUCKET.value)
sme_educacao_basica_avaliacao_dbt.run_config = KubernetesRun(
    image=constants.DOCKER_IMAGE.value,
    labels=[
        constants.RJ_SME_AGENT_LABEL.value,
    ],
)

sme_educacao_basica_avaliacao_dbt_default_parameters = {}

sme_educacao_basica_avaliacao_dbt = set_default_parameters(
    sme_educacao_basica_avaliacao_dbt,
    default_parameters=sme_educacao_basica_avaliacao_dbt_default_parameters,
)

sme_educacao_basica_avaliacao_dbt.schedule = educacao_basica_avaliacao_update_schedule

# add comment to trigger build of new models in queries\models\educacao_basica_avaliacao
