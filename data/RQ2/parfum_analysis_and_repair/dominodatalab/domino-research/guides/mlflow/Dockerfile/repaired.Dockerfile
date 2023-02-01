FROM continuumio/miniconda3:latest
RUN pip install --no-cache-dir mlflow boto3 pymysql
