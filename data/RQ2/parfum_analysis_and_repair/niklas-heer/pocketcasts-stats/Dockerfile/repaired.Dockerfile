# See https://hub.docker.com/r/library/python/
FROM python:3.7-alpine

LABEL Name=pocketcasts-stats

WORKDIR /app
COPY . /app

# Using pip: