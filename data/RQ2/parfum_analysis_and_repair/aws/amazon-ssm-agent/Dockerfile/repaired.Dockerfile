FROM golang:1.17

RUN apt -y update && apt -y upgrade && apt -y --no-install-recommends install rpm tar gzip wget zip && apt clean all && rm -rf /var/lib/apt/lists/*;

RUN mkdir /amazon-ssm-agent
WORKDIR /amazon-ssm-agent
