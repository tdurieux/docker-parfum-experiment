FROM python:3.8-slim

COPY . /app
WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends -y git graphviz \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install pipenv && pipenv install --skip-lock

WORKDIR /app/quark
ENTRYPOINT ["pipenv", "run"]
