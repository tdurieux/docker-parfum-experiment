ARG PYTHON_VER="3.7"

FROM python:${PYTHON_VER}

RUN pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir poetry

WORKDIR /local
COPY pyproject.toml poetry.lock /local/

RUN poetry config virtualenvs.create false \
  && poetry install --no-interaction --no-ansi --no-root

COPY . /local
RUN poetry install --no-interaction --no-ansi

