FROM python:3.6.12-alpine

RUN pip install --no-cache-dir airflow-docker-helper

WORKDIR /usr/local/lib/airflow-docker/scripts
COPY scripts/ .

ENTRYPOINT ["python"]
