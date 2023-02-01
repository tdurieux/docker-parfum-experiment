FROM python:3.9.4

RUN pip install --no-cache-dir -U pip pip-tools

RUN mkdir /code
WORKDIR /code

COPY .docker/lint/py-requirements.lock /code/

RUN pip install --no-cache-dir -r py-requirements.lock
