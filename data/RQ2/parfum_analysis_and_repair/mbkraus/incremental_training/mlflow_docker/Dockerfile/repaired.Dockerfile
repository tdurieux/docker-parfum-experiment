FROM python:3.7.0

RUN pip install --no-cache-dir mlflow==1.2.0

EXPOSE 5000