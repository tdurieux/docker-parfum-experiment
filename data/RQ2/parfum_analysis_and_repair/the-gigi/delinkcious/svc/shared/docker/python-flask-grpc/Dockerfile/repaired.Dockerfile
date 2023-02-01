FROM python:alpine
RUN apk add --no-cache build-base
COPY requirements.txt /tmp
WORKDIR /tmp
RUN pip install --no-cache-dir -r requirements.txt
