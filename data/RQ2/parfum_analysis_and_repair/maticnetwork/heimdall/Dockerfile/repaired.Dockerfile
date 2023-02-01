FROM golang:latest

ARG HEIMDALL_DIR=/var/lib/heimdall
ENV HEIMDALL_DIR=$HEIMDALL_DIR

RUN apt-get update -y && apt-get upgrade -y \
    && apt install --no-install-recommends build-essential git -y \
    && mkdir -p $HEIMDALL_DIR && rm -rf /var/lib/apt/lists/*;

WORKDIR /heimdall
COPY . .

RUN make install

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh

ENV SHELL /bin/bash
EXPOSE 1317 26656 26657

ENTRYPOINT ["entrypoint.sh"]
