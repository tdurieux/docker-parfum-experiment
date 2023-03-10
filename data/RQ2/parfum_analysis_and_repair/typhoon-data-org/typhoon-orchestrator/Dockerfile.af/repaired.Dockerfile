FROM puckel/docker-airflow:1.10.9

ENV AIRFLOW_HOME="/usr/local/airflow"
ENV PROJECT_NAME="typhoon_project"
ENV TYPHOON_BASE="/opt/typhoon"
ENV TYPHOON_HOME="$TYPHOON_BASE/$PROJECT_NAME/"
ENV PYTHONPATH="$PYTHONPATH:$TYPHOON_HOME"

USER root
RUN set -ex && apt-get update -yqq \
    && apt-get upgrade -yqq \
    && apt-get install -yqq --no-install-recommends \
        libpq-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /
COPY . /
RUN pip install --no-cache-dir -e ./[dev]
RUN mkdir $TYPHOON_BASE && chown -R airflow: ${TYPHOON_BASE} && mkdir /tmp/data_lake && chown -R airflow: /tmp/data_lake

USER airflow
WORKDIR $TYPHOON_BASE
RUN typhoon init $PROJECT_NAME --deploy-target airflow && cd $PROJECT_NAME
WORKDIR $TYPHOON_HOME
