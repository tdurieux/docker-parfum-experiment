FROM python:3.8

WORKDIR /mlflow/projects/code
COPY ./requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT /bin/bash
