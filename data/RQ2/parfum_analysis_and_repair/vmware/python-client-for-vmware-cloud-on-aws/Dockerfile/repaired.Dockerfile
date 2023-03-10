FROM python:3.7-alpine

COPY . /app

WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt
RUN apk add --no-cache bash
