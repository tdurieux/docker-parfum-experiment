ARG VERSION
FROM python:${VERSION}-buster

RUN pip install --no-cache-dir poetry==1.0.10
COPY . /app
WORKDIR /app

ENV POETRY_VIRTUALENVS_CREATE=false
RUN poetry install --no-interaction --extras "sparse"
