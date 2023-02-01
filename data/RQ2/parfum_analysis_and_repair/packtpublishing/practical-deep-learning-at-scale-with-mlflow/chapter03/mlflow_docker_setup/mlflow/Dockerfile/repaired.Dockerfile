FROM python:3.8-slim-buster
# Install python packages
RUN pip install --no-cache-dir mlflow boto3 pymysql