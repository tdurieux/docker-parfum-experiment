FROM python:3.7
MAINTAINER "viktor.pecheniuk@gmail.com"

# Airflow setup
ARG AIRFLOW_VERSION=1.10.2
ARG JSON_LOGGER_VERSION=0.1.10
ARG PROMETHEUS_CLI_VERSION=0.5.0
ARG K8S_VERSION=9.0.0

ENV AIRFLOW_HOME=/app/airflow
ENV SLUGIFY_USES_TEXT_UNIDECODE=yes
ENV PYTHONPATH=$AIRFLOW_HOME

RUN apt-get update \
  && apt-get install --no-install-recommends -y supervisor vim \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/* \
  && pip install --no-cache-dir apache-airflow[postgres]==${AIRFLOW_VERSION} \
  && pip install --no-cache-dir python-json-logger==${JSON_LOGGER_VERSION} \
  && pip install --no-cache-dir prometheus-client==${PROMETHEUS_CLI_VERSION} \
  && pip install --no-cache-dir kubernetes==${K8S_VERSION} \
  && pip install --no-cache-dir psycopg2

# replace owns configs
COPY ./conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./conf/airflow.cfg $AIRFLOW_HOME/airflow.cfg

COPY . $AIRFLOW_HOME/
RUN rm -rf $AIRFLOW_HOME/conf

# run tests before deploy
RUN airflow initdb \
  && cd $AIRFLOW_HOME && python -m unittest tests/unit/*

EXPOSE 5001

CMD ["/usr/bin/supervisord"]
