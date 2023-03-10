FROM python:3.8-alpine

ENV C_FORCE_ROOT true

# Prompt non-interactive
ENV DEBIAN_FRONTEND=noninteractive

RUN apk add --no-cache build-base
RUN pip install --no-cache-dir uvicorn==0.11.5 uvloop==0.14.0

COPY . /api
WORKDIR /api

# install requirements
RUN pip install --no-cache-dir -r requirements.txt

# run the app server
CMD uvicorn --host 0.0.0.0 --port $INTERNAL_API_PORT --workers 4 app:app