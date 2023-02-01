FROM ubuntu:18.04
ARG GO=1.14.2

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
  apt-get install --no-install-recommends -y zip ghp-import git python-pkg-resources && \
  rm -rf /var/lib/apt/lists/*

COPY --from=golang /usr/local/go /usr/local/go
ENV GOROOT=/usr/local/go
ENV PATH=$GOROOT/bin:$PATH

ENV HOME=/var/jenkins_home
