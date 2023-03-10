FROM python:3.9-slim-buster

ENV BUILD_DEPS gcc g++

RUN apt-get update && apt-get install -y $BUILD_DEPS --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir cchardet

RUN apt-get purge -y --auto-remove $BUILD_DEPS
