FROM python:3.10.4-slim-buster
USER root

# PSQL Requirements
RUN apt-get update && apt-get install --no-install-recommends -y libpq-dev build-essential && rm -rf /var/lib/apt/lists/*;

# pip3 upgrade
RUN pip3 install --no-cache-dir --upgrade pip

# Linting
RUN pip3 install --no-cache-dir flake8

# Testing
RUN pip3 install --no-cache-dir pytest
RUN pip3 install --no-cache-dir pytest-cov

# Dev Requirements
ADD dev-requirements.txt .
RUN pip3 install --no-cache-dir -r dev-requirements.txt

# Airflow env
ENV AIRFLOW_HOME='/usr/local/airflow'

# wd
WORKDIR /gusty

# Sleep forever
CMD sleep infinity
