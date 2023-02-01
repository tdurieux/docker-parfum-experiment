ARG NAMESPACE="balena"
ARG TAG="latest"
FROM ${NAMESPACE}/balena-push-env:${TAG}

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip udev && rm -rf /var/lib/apt/lists/*
RUN pip3 install --no-cache-dir awscli

COPY include/balena-api.inc include/balena-lib.inc entry_scripts/balena-generate-ami.sh /
WORKDIR /
