FROM python:3.10-slim

ENV PATH=$PATH:/root/.local/bin
ENV POETRY_VIRTUALENVS_CREATE=false

RUN apt-get update \
    && apt-get install --no-install-recommends -y curl git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl -f -sSL https://install.python-poetry.org | python -
