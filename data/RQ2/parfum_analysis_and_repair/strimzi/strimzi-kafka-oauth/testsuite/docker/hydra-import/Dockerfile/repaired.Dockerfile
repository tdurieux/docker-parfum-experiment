FROM alpine

RUN apk add -U --no-cache bash ca-certificates curl \
    && mkdir /tmp/hydra \
    && cd /tmp/hydra \
    && wget -q https://github.com/ory/hydra/releases/download/v1.0.0/hydra_1.0.0_Linux_32-bit.tar.gz \
    && tar xvzf hydra_1.0.0_Linux_32-bit.tar.gz \
    && cp hydra /usr/bin/ \
    && cd \
    && rm -rf /tmp/hydra && rm hydra_1.0.0_Linux_32-bit.tar.gz
