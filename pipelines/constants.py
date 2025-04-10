# -*- coding: utf-8 -*-
from enum import Enum


class constants(Enum):
    ######################################
    # Automatically managed,
    # please do not change these values
    ######################################
    # Docker image
    DOCKER_TAG = "AUTO_REPLACE_DOCKER_TAG"
    DOCKER_IMAGE_NAME = "AUTO_REPLACE_DOCKER_IMAGE"
    DOCKER_IMAGE = f"{DOCKER_IMAGE_NAME}:{DOCKER_TAG}"
    GCS_FLOWS_BUCKET = "datario-public"

    ######################################
    # Agent labels
    ######################################
    # EXAMPLE_AGENT_LABEL = "example_agent"
    RJ_SME_AGENT_LABEL = "sme"

    ######################################
    # Other constants
    ######################################
    # EXAMPLE_CONSTANT = "example_constant"

    ######################################
    # DBT TRANSFORM
    ######################################
    GCS_BUCKET = {"prod": "rj-sme_dbt", "dev": "rj-sme-dev_dbt"}
    REPOSITORY_URL = "https://github.com/prefeitura-rio/pipelines_rj_sme.git"
