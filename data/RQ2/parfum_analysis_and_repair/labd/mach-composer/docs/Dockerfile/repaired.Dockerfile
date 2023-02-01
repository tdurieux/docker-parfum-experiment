FROM python:3.7-alpine3.8

RUN mkdir /site
RUN mkdir /build
WORKDIR /source

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY mkdocs.yml .
COPY docs docs
