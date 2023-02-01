ARG PYTHON_VER

FROM python:${PYTHON_VER}-slim

RUN pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir poetry

WORKDIR /local
COPY . /local

RUN poetry config virtualenvs.create false \
  && poetry install --no-interaction --no-ansi
