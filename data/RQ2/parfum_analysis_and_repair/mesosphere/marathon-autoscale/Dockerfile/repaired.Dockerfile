#
# Docker image that can be run under Marathon management to dynamically scale a Marathon service running on DC/OS.
#

FROM python:3-alpine

# Copy the python scripts into the working directory
ADD / /marathon-autoscale
WORKDIR /marathon-autoscale

RUN apk add --no-cache --update --virtual .build-dependencies openssl-dev libffi-dev python-dev make gcc g++
RUN pip install --no-cache-dir -r requirements.txt

# Start the autoscale application
CMD python marathon_autoscaler.py
