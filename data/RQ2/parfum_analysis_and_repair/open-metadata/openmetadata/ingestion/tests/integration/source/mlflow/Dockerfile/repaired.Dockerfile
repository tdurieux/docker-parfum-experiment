FROM python:3.8.13-slim-buster

RUN python -m pip install --upgrade pip

RUN pip install --no-cache-dir cryptography mlflow boto3 pymysql

EXPOSE 5000
