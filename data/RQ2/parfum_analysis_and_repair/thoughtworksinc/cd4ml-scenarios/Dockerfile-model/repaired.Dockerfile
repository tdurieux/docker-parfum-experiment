FROM python:3.9-slim-buster

USER root
ENV FLUENTD_HOST "fluentd"
ENV FLUENTD_PORT "24224"
ENV FLASK_APP "cd4ml/app.py"
ENV FLASK_ENV "production"
ENV MLFLOW_TRACKING_URL "http://mlflow:5000"

RUN mkdir -p /app/cd4ml/
WORKDIR /app/cd4ml/

COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

COPY cd4ml .

EXPOSE 5005
WORKDIR /app
CMD flask run --host=0.0.0.0 --port 5005