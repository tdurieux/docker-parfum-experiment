# This container is used as a base by Dockerfile.test.arm64 in order to speed up dependency install for testing purposes only
FROM arm64v8/python:3.8-alpine

WORKDIR /usr/src/core
# Install necessary base dependencies and set UTC timezone for apscheduler
RUN apk --no-cache upgrade && apk --no-cache add libffi libstdc++ gmp && echo "UTC" > /etc/timezone

# Install dev build dependencies
RUN apk --no-cache add g++ make gmp-dev libffi-dev automake autoconf libtool
# Install python dev dependencies
ENV SECP_BUNDLED_EXPERIMENTAL 1
ENV SECP_BUNDLED_WITH_BIGNUM 1
COPY requirements.txt .
RUN python3 -m pip install --no-cache-dir -r requirements.txt
COPY dev_requirements.txt .
RUN python3 -m pip install --no-cache-dir --upgrade -r dev_requirements.txt

# Install Helm for chart linting and/or yq for doc builds if it doesn't exist