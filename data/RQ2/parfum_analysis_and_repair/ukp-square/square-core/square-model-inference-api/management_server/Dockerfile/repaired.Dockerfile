FROM python:3.7.6-slim-buster as base

ENV PYTHONUNBUFFERED 1

RUN apt-get -y update && apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Deployment stage
FROM base as build

COPY ./app app
COPY main.py main.py
COPY docker_access.py docker_access.py
COPY logging.conf logging.conf
COPY ./tasks tasks
COPY ./mongo_access.py mongo_access.py

EXPOSE 9001
