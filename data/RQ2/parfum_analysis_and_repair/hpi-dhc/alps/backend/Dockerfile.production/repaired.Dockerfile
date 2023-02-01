FROM python:3.7-slim as build

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    POETRY_VIRTUALENVS_CREATE=FALSE \
    POETRY_VERSION=1.0.4

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential libpq-dev libsnappy-dev git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir gunicorn "poetry==${POETRY_VERSION}"

WORKDIR /app/

COPY pyproject.toml poetry.lock /app/

RUN poetry install --no-dev --no-interaction --no-ansi

COPY . /app/

RUN mkdir ./staticfiles

EXPOSE 8000

CMD [ "gunicorn", "--bind", ":8000", "backend.wsgi:application" ]