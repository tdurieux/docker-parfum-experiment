FROM python:3.7.3-stretch

RUN apt-get update && \
    apt-get install -y --no-install-recommends libbz2-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /gridpaste

COPY pyproject.toml .

RUN poetry install

COPY . .

ENTRYPOINT [ "python", "gridpaste" ]
