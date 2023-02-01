FROM debian:stretch-slim

ARG SHELL_NAME
ARG SHELL_PKG

RUN \
    apt-get update && \
    apt-get install --no-install-recommends -yy -q ${SHELL_PKG} curl make && \
    sh -c "$( curl -f -L https://raw.github.com/rylnd/shpec/master/install.sh)" -f && rm -rf /var/lib/apt/lists/*;

ENV SHELL ${SHELL_NAME}

VOLUME "/tmp/wtfc"
WORKDIR "/tmp/wtfc"

CMD ${SHELL} -c shpec