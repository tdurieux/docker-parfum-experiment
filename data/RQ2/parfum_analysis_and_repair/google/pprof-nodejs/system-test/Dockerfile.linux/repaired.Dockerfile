FROM golang:1.17-stretch as builder
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /root/
RUN go get github.com/google/pprof

FROM debian:11

ARG NODE_VERSION
ARG ADDITIONAL_PACKAGES
ARG VERIFY_TIME_LINE_NUMBERS

RUN apt-get update && apt-get install --no-install-recommends -y curl $ADDITIONAL_PACKAGES \
    && rm -rf /var/lib/apt/lists/*

ENV NVM_DIR /bin/.nvm
RUN mkdir -p $NVM_DIR


# Install nvm with node and npm
RUN curl -f -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION

ENV BASH_ENV /root/.bashrc

WORKDIR /root/
COPY --from=builder /go/bin/pprof /bin
