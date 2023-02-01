FROM python:3.8-slim-buster
WORKDIR /code
COPY . /code/

RUN pip install --no-cache-dir . && \
    stac-validator --help

ENTRYPOINT ["stac-validator"]
