FROM continuumio/miniconda3:latest

RUN pip install --no-cache-dir mlflow boto3 pymysql

ADD . /app
WORKDIR /app

COPY wait-for-it.sh wait-for-it.sh
RUN chmod +x wait-for-it.sh

