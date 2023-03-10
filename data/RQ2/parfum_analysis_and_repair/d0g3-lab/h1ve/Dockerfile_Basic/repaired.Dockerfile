#--- Build ---
FROM python:3.7-alpine
RUN apk update && \
    apk add python-dev linux-headers libffi-dev gcc make musl-dev py-pip mysql-client git openssl-dev docker && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache/

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
