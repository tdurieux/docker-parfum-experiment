FROM python:3.8-buster AS base

COPY ./back /app/back

COPY ./configuration_templates /app/configuration_templates

WORKDIR /app/back

RUN pip install --no-cache-dir -r requirements.txt
