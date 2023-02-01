FROM python:3.7-slim

ENV POETRY_VIRTUALENVS_CREATE=FALSE \
    POETRY_VERSION=1.0.4

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential libpq-dev libsnappy-dev git && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

RUN pip install --no-cache-dir "poetry==${POETRY_VERSION}"

COPY pyproject.toml poetry.lock /app/
RUN poetry install --no-interaction --no-ansi

COPY . /app