# -*- coding: utf-8 -*-
from datetime import datetime, timedelta
from typing import List
from prefect.schedules.clocks import IntervalClock

def generate_dbt_schedules(  # pylint: disable=too-many-arguments,too-many-locals
    interval: timedelta,
    start_date: datetime,
    labels: List[str],
    dataset_id: str,
    table_parameters: dict,
    runs_interval_minutes: int = 1,
) -> List[IntervalClock]:
    """
    Generates multiple schedules for dbt model execution.
    """
    clocks = []
    for count, (table_id, parameters) in enumerate(table_parameters.items()):
        parameter_defaults = {
            "dataset_id": dataset_id if dataset_id != "" else parameters["dataset_id"],
            "table_id": table_id,
        }
        if "dbt_alias" in parameters:
            parameter_defaults["dbt_alias"] = parameters["dbt_alias"]
        if "upstream" in parameters:
            parameter_defaults["upstream"] = parameters["upstream"]
        if "downstream" in parameters:
            parameter_defaults["downstream"] = parameters["downstream"]
        if "exclude" in parameters:
            parameter_defaults["exclude"] = parameters["exclude"]
        if "flags" in parameters:
            parameter_defaults["flags"] = parameters["flags"]
        if "vars_" in parameters:
            parameter_defaults["vars_"] = parameters["vars_"]
        if "partition_columns" in parameters:
            parameter_defaults["partition_columns"] = parameters["partition_columns"]
        if "materialize_after_dump" in parameters:
            parameter_defaults["materialize_after_dump"] = parameters["materialize_after_dump"]
        if "materialization_mode" in parameters:
            parameter_defaults["materialization_mode"] = parameters["materialization_mode"]
        if "materialize_to_datario" in parameters:
            parameter_defaults["materialize_to_datario"] = parameters["materialize_to_datario"]
        if "dbt_model_secret_parameters" in parameters:
            parameter_defaults["dbt_model_secret_parameters"] = parameters["dbt_model_secret_parameters"]

        new_interval = parameters["interval"] if "interval" in parameters else interval

        clocks.append(
            IntervalClock(
                interval=new_interval,
                start_date=start_date + timedelta(minutes=runs_interval_minutes * count),
                labels=labels,
                parameter_defaults=parameter_defaults,
            )
        )
    return clocks