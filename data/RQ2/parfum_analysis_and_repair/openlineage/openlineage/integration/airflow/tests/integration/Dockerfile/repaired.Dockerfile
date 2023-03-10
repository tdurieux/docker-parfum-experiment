FROM openlineage-airflow-base:latest AS build

FROM apache/airflow:1.10.15-python3.7 AS airflow
COPY --from=build /app/wheel /whl
USER root
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29  # Mysql fix for https://github.com/apache/airflow/issues/20911
RUN apt-get update && \
    apt-get install --no-install-recommends -y git build-essential && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /opt/airflow
COPY data /opt/data
COPY docker/wait-for-it.sh /opt/data/wait-for-it.sh
RUN chown -R airflow:airflow /opt/airflow
RUN chmod -R 777 /opt/data
USER airflow
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir --user -r requirements.txt

FROM openlineage-airflow-base:latest AS integration
RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-dev default-libmysqlclient-dev build-essential && rm -rf /var/lib/apt/lists/*;
COPY integration-requirements.txt integration-requirements.txt
COPY *.py ./
COPY requests requests
RUN pip install --no-cache-dir --use-deprecated=legacy-resolver --user -r integration-requirements.txt
COPY docker/wait-for-it.sh wait-for-it.sh
