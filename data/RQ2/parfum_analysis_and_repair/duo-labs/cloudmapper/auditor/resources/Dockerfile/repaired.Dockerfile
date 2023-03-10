FROM python:3.7-slim as cloudmapper

LABEL maintainer="https://github.com/0xdabbad00/"
LABEL Project="https://github.com/duo-labs/cloudmapper"

WORKDIR /opt/cloudmapper
ENV AWS_DEFAULT_REGION=us-east-1

RUN apt-get update -y && apt-get install --no-install-recommends -y build-essential autoconf automake libtool python3.7-dev python3-tk jq awscli && rm -rf /var/lib/apt/lists/*;

COPY cloudmapper/. /opt/cloudmapper
COPY entrypoint.sh /opt/cloudmapper/entrypoint.sh

# Remove the demo data
RUN rm -rf /opt/cloudmapper/account-data/demo

# Install the python libraries needed for CloudMapper
RUN cd /opt/cloudmapper && pip install --no-cache-dir -r requirements.txt

ENTRYPOINT /opt/cloudmapper/entrypoint.sh
