FROM python:3.7.2-slim

WORKDIR /opt

ADD Pipfile Pipfile
ADD Pipfile.lock Pipfile.lock

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y build-essential && \
    pip install --no-cache-dir -U pip && \
    pip install --no-cache-dir -U pipenv && \
    pipenv install --system --dev --deploy && \
    apt-get remove -y build-essential && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD scrapy.cfg scrapy.cfg
ADD cicero /opt/cicero
