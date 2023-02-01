FROM python:3.7-slim as cloudmapper

LABEL maintainer="https://github.com/0xdabbad00/"
LABEL Project="https://github.com/duo-labs/cloudmapper"

EXPOSE 8000
WORKDIR /opt/cloudmapper
ENV AWS_DEFAULT_REGION=us-east-1

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y build-essential autoconf automake libtool python3-tk jq awscli && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y bash && rm -rf /var/lib/apt/lists/*;

COPY . /opt/cloudmapper
RUN pip install --no-cache-dir -r requirements.txt

RUN bash
