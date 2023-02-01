# public OSS users should simply leave this argument blank or ignore its presence entirely
ARG REGISTRY=""
FROM ${REGISTRY}ubuntu:22.04

RUN apt update && apt install --no-install-recommends -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash - && apt install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*

RUN npm install -g autorest && npm cache clean --force;

ENTRYPOINT [ "autorest" ]
