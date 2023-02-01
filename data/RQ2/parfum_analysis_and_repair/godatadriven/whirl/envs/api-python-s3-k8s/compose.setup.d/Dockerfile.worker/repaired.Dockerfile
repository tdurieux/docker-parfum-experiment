ARG AIRFLOW_VERSION=2.2.2
ARG PYTHON_VERSION=3.7
FROM apache/airflow:${AIRFLOW_VERSION}-python${PYTHON_VERSION}

ARG DAG_SUBDIR
RUN pip install --no-cache-dir pandas pyarrow

COPY . /opt/airflow/dags/${DAG_SUBDIR}/
