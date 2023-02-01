FROM antonapetrov/uvicorn-gunicorn-fastapi:python3.9

# install Poetry
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | POETRY_HOME=/opt/poetry python && \
    cd /usr/local/bin && \
    ln -s /opt/poetry/bin/poetry && \
    poetry config virtualenvs.create false

ENV MODULE_NAME=api.main

COPY pyproject.toml poetry.lock /app/
RUN poetry install --no-root --no-dev
COPY . /app

