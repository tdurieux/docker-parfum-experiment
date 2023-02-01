FROM ubuntu:jammy
MAINTAINER peter.ebden@gmail.com

# A few miscellaneous dependencies.
RUN apt-get update && apt-get install --no-install-recommends -y curl git gcc xz-utils && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Go
RUN curl -fsSL https://dl.google.com/go/go1.18.2.linux-amd64.tar.gz | tar -xzC /usr/local
RUN ln -s /usr/local/go/bin/go /usr/local/bin/go && ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt
RUN GOOS=freebsd go install std

WORKDIR /tmp
