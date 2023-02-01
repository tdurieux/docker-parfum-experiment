FROM python:3.6

USER root
RUN apt-get update && apt-get install --no-install-recommends -y gcc unzip vim && rm -rf /var/lib/apt/lists/*;

COPY ./plugins /dbnd/plugins/
COPY ./modules /dbnd/modules/
COPY ./examples /dbnd/examples/

COPY ./setup.cfg /dbnd/modules/dbnd/setup.cfg
COPY ./setup.cfg /dbnd/modules/dbnd-airflow/setup.cfg
COPY ./setup.cfg /dbnd/examples/setup.cfg
COPY ./setup.cfg /dbnd/plugins/*/setup.cfg

COPY ./project.cfg /dbnd/

RUN pip install --no-cache-dir pip==21.3.1# python 3.6

ARG AIRFLOW_EXTRA=airflow
RUN pip install --no-cache-dir -e /dbnd/modules/dbnd
RUN pip install --no-cache-dir -e /dbnd/modules/dbnd-airflow[$AIRFLOW_EXTRA]
RUN pip install --no-cache-dir -e /dbnd/examples
RUN pip install --no-cache-dir -e /dbnd/plugins/dbnd-aws
RUN pip install --no-cache-dir -e /dbnd/plugins/dbnd-docker
RUN pip install --no-cache-dir -e /dbnd/plugins/dbnd-airflow-auto-tracking

WORKDIR /dbnd

ENTRYPOINT "/bin/bash"
