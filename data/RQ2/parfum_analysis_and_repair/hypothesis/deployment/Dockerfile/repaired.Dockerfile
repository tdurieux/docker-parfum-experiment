FROM python:3.9.7-alpine3.14

RUN apk add --no-cache bash jq zip

COPY requirements/requirements.txt /src/requirements.txt
RUN pip install --no-cache-dir -r /src/requirements.txt