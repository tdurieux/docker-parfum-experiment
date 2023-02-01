FROM alpine

ARG DCW_VERSION=2.9.0
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/${DCW_VERSION}/wait /usr/local/bin/wait
RUN chmod +x /usr/local/bin/wait