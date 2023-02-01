ARG GO_VERSION
FROM golang:${GO_VERSION}
RUN apt update && apt install --no-install-recommends -y ruby ruby-dev rubygems build-essential rpm && \
    gem install --no-document fpm && rm -rf /var/lib/apt/lists/*;
WORKDIR /work
COPY . /work