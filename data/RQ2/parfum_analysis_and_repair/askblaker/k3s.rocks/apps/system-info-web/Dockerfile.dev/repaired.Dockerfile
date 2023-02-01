FROM python:3.8-slim-buster

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app/

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | POETRY_HOME=/opt/poetry python && \
    cd /usr/local/bin && \
    ln -s /opt/poetry/bin/poetry && \
    poetry config virtualenvs.create false

COPY ./app/pyproject.toml ./app/poetry.lock* /app/

RUN poetry install --no-root

COPY ./app ./
RUN chmod +x ./start.sh

ENV PYTHONPATH /app

CMD ["./start.sh"]