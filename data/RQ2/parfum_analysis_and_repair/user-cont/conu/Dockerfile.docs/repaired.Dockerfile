FROM python:3

RUN pip3 install --no-cache-dir sphinx

RUN mkdir /src

WORKDIR /src
