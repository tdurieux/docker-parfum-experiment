FROM python:3.10-slim-buster

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    gcc && rm -rf /var/lib/apt/lists/*;

WORKDIR /app/

COPY .github/workflows/constraints.txt .
RUN pip install --no-cache-dir --constraint=constraints.txt poetry nox

COPY pyproject.toml poetry.lock /app/
RUN poetry install --no-root --no-dev

COPY . /app/
RUN poetry install -E jupyter --no-dev
