#!/bin/bash
FROM python:3.6.10-buster
LABEL Nathan Workman <nathancworkman@gmail.com>

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get -y upgrade && apt-get install -y --no-install-recommends sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git apt-utils build-essential && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY ./requirements.txt .
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
