FROM python:3.6-stretch

RUN mkdir /opt/pipeline_workflows/
WORKDIR /opt/pipeline_workflows/
ENV AIRFLOW__CORE__LOAD_EXAMPLES False
ENV AIRFLOW__CORE__DAGS_FOLDER /opt/pipeline_workflows/src/main/python/dags
# ENV AIRFLOW__CORE__PLUGINS_FOLDER /opt/src/main/python/plugins
# ENV AIRFLOW__REST_API_PLUGIN__LOG_LOADING True
ENV AIRFLOW__REST_API_PLUGIN__FILTER_LOADING_MESSAGES_IN_CLI_RESPONSE True
# ENV AIRFLOW__REST_API_PLUGIN__REST_API_PLUGIN_HTTP_TOKEN_HEADER_NAME rest_api_plugin_http_token
ENV AIRFLOW__REST_API_PLUGIN__REST_API_PLUGIN_EXPECTED_HTTP_TOKEN None

ENV AIRFLOW_HOME /usr/local/airflow



RUN apt update && apt upgrade -y && pip install --no-cache-dir -U pip && \
  pip install --no-cache-dir pybuilder

COPY build.py .
RUN  pyb install_dependencies

COPY requirements.txt .
RUN --mount=type=cache,target=/root/.cache/pip pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir apache-airflow[kubernetes]==1.10.6
# COPY src/unittest/python/resources/variables.json /usr/local/airflow/variables.json
# COPY src/unittest/python/resources/connections.sh /usr/local/airflow/connections.sh

RUN   airflow initdb
# RUN   airflow initdb && \
#   airflow variables -i /usr/local/airflow/variable.json && \
#   sh /usr/local/airflow/connections.sh

RUN rm -f /opt/pipeline_workflows/build.py
# RUN rm -f /usr/local/airflow/variables.json
# RUN rm -f /usr/local/airflow/connections.sh

COPY script/entrypoint.sh /mnt/entrypoint.sh
RUN chmod +x /mnt/entrypoint.sh

ENV PYTHONPATH /opt/pipeline_workflows/src/

ENTRYPOINT ["/mnt/entrypoint.sh"]

CMD ["install_dependencies",""]