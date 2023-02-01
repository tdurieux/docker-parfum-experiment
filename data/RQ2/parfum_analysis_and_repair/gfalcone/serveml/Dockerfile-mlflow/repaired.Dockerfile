FROM python:3.7-buster as base

COPY requirements.txt /tmp/

RUN pip install --no-cache-dir -r /tmp/requirements.txt

ENV BUILD_DIRECTORY=$(pwd)
ENV MLFLOW_TRACKING_URI http://localhost:5000

CMD mlflow server --backend-store-uri sqlite:///database.db --default-artifact-root file:///tmp/mlflow --host 0.0.0.0