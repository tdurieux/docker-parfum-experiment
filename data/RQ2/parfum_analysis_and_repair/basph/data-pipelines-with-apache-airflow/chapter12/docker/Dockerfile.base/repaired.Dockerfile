FROM apache/airflow:1.10.11-python3.7

COPY requirements.txt /opt/airflow/requirements.txt

USER root

RUN apt-get update && \
    apt-get install --no-install-recommends -y gcc && \
    pip install --no-cache-dir -r /opt/airflow/requirements.txt && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

USER airflow
