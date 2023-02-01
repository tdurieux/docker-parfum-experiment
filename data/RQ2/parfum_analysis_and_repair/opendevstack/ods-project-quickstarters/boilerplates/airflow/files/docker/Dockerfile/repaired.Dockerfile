# This is a dummy value which OpenShift replaces during build time
FROM oc.registry.url/shared-services/airflow:1.10.3

ARG nexusHostWithBasicAuth

COPY dist/requirements.txt ${AIRFLOW_HOME}/
COPY dist/dags ${AIRFLOW_HOME}/dags
COPY dist/dag_deps ${AIRFLOW_HOME}/dag_deps
COPY scripts/setup.py ${AIRFLOW_HOME}/dag_deps

USER root

RUN pip install --no-cache-dir ${AIRFLOW_HOME}/dag_deps && \
    if [[ ! -z ${nexus_url} ]]; \
    then \
    pip install --no-cache-dir -i ${nexusHostWithBasicAuth}/repository/pypi-all/simple -r ${AIRFLOW_HOME}/requirements.txt; \
    else pip install --no-cache-dir -r ${AIRFLOW_HOME}/requirements.txt; \
    fi

USER 1001