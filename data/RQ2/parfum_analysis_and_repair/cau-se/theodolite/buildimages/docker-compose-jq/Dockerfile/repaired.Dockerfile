FROM docker:${DOCKER_VERSION:-latest}

RUN apk update && \
    apk add --no-cache jq && \
    apk add --no-cache py-pip python3-dev libffi-dev openssl-dev gcc libc-dev rust cargo make && \
    pip install --no-cache-dir docker-compose
