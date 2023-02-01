FROM python:3.10.2-buster

ENV PIP_NO_CACHE_DIR "true"

COPY ./requirements*.txt /code/

WORKDIR /code

RUN pip install --no-cache-dir -r requirements.txt -r
