FROM python:2-alpine
RUN apk add --no-cache -U gcc musl-dev linux-headers openssl-dev libffi-dev && pip install --no-cache-dir jira-cli
