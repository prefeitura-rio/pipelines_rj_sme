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

sme_core_sso_queries = {
    "SYS_Entidade": {
        "biglake_table": True,
        "materialize_after_dump": False,
        "materialization_mode": "prod",
        "materialize_to_datario": False,
        "dump_to_gcs": False,
        "dump_mode": "overwrite",
        "execute_query": """
            SELECT  ent_id,
                    ten_id,
                    ent_codigo,
                    ent_nomeFantasia,
                    ent_razaoSocial,
                    ent_sigla,
                    ent_cnpj,
                    ent_inscricaoMunicipal,
                    ent_inscricaoEstadual,
                    ent_idSuperior,
                    ent_situacao,
                    ent_dataCriacao,
                    ent_dataAlteracao,
                    ent_integridade,
                    GETDATE() AS loaded_at
            FROM CoreSSO.dbo.SYS_Entidade;
        """,
    },
    "SYS_DiaNaoUtil": {
        "biglake_table": True,
        "materialize_after_dump": False,
        "materialization_mode": "prod",
        "materialize_to_datario": False,
        "dump_to_gcs": False,
        "dump_mode": "overwrite",
        "execute_query": """
            SELECT  dnu_id,
                    dnu_nome,
                    dnu_abrangencia,
                    dnu_descricao,
                    dnu_data,
                    dnu_recorrencia,
                    dnu_vigenciaInicio,
                    dnu_vigenciaFim,
                    cid_id, unf_id,
                    dnu_situacao,
                    dnu_dataCriacao,
                    dnu_dataAlteracao,
                    GETDATE() AS loaded_at
            FROM CoreSSO.dbo.SYS_DiaNaoUtil;
        """,
    },
    "SYS_EntidadeEndereco": {
        "biglake_table": True,
        "materialize_after_dump": False,
        "materialization_mode": "prod",
        "materialize_to_datario": False,
        "dump_to_gcs": False,
        "dump_mode": "overwrite",
        "execute_query": """
            SELECT  ent_id,
                    ene_id,
                    end_id,
                    ene_numero,
                    ene_complemento,
                    ene_situacao,
                    ene_dataCriacao,
                    ene_dataAlteracao
            FROM CoreSSO.dbo.SYS_EntidadeEndereco;
        """,
    },
    "END_Endereco": {
        "biglake_table": True,
        "materialize_after_dump": False,
        "materialization_mode": "prod",
        "materialize_to_datario": False,
        "dump_to_gcs": False,
        "dump_mode": "overwrite",
        "execute_query": """
            SELECT  end_id,
                    end_cep,
                    end_logradouro,
                    end_bairro,
                    end_distrito,
                    end_zona,
                    cid_id,
                    end_situacao,
                    end_dataCriacao,
                    end_dataAlteracao,
                    end_integridade
            FROM CoreSSO.dbo.END_Endereco;
        """,
    },
    "END_Cidade": {
        "biglake_table": True,
        "materialize_after_dump": False,
        "materialization_mode": "prod",
        "materialize_to_datario": False,
        "dump_to_gcs": False,
        "dump_mode": "overwrite",
        "execute_query": """
            SELECT  cid_id,
                    pai_id,
                    unf_id,
                    cid_nome,
                    cid_ddd,
                    cid_situacao,
                    cid_integridade
            FROM CoreSSO.dbo.END_Cidade;
        """,
    },
}


sme_clocks = generate_dump_db_schedules(
    interval=timedelta(days=1),
    start_date=datetime(2022, 1, 1, 21, 0, tzinfo=pytz.timezone("America/Sao_Paulo")),
    labels=[
        constants.RJ_SME_AGENT_LABEL.value,
    ],
    db_database="CoreSSO",
    db_host="10.70.6.103",
    db_port="1433",
    db_type="sql_server",
    dataset_id="brutos_core_sso",
    infisical_secret_path="/db-educacao-basica",
    table_parameters=sme_core_sso_queries,
)

sme_brutos_core_sso_daily_update_schedule = Schedule(clocks=untuple(sme_clocks))
