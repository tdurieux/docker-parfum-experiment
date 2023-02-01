FROM python:3.9

RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir sqlparse

RUN mkdir /code
WORKDIR /code
