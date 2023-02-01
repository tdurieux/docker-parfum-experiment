FROM python:3.8-alpine

RUN pip install --upgrade pip \
 && pip install --upgrade setuptools

COPY content /app

RUN pip install -r /app/requirements.txt

WORKDIR app