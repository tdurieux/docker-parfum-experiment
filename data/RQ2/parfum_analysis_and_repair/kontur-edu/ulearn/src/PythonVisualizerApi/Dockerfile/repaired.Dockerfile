FROM python:3.8-alpine

RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir --upgrade setuptools

COPY content /app

RUN pip install --no-cache-dir -r /app/requirements.txt

WORKDIR app