FROM python:3.7

RUN pip3 install --no-cache-dir requests flask prometheus_client flask-cors

WORKDIR /gpu-reporter

COPY * /gpu-reporter/
