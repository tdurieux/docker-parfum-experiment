FROM python:3-alpine
ADD / /marathon-autoscale
WORKDIR /marathon-autoscale
RUN apk add --no-cache --update --virtual .build-dependencies openssl-dev libffi-dev python-dev make gcc g++
RUN pip install --no-cache-dir -r requirements.txt
CMD python marathon_autoscaler.py
