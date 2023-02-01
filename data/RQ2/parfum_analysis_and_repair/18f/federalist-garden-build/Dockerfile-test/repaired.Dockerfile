FROM python:3.8

SHELL ["/bin/bash", "-c"]

RUN groupadd -r rvm \
  && useradd --no-log-init --system --create-home --groups rvm customer

WORKDIR /app

COPY ./requirements.txt ./requirements.txt
COPY ./requirements-dev.txt ./requirements-dev.txt

RUN pip install --no-cache-dir -r requirements-dev.txt