# docker build --rm -t github-ci-base:latest -f .github/Dockerfile.base .
FROM ubuntu:bionic

RUN apt update && apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

# https://github.com/golang/go/wiki/Ubuntu
RUN add-apt-repository ppa:longsleep/golang-backports

RUN apt update \
    && apt install --no-install-recommends -y build-essential cmake python3 python3-pip wget git \
        golang-1.13-go curl && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -U pip && pip3 install --no-cache-dir numpy==1.16 tensorflow==1.13.2

ENV GOROOT /usr/lib/go-1.13
ENV PATH ${GOROOT}/bin:${PATH}
ENV TF_CPP_MIN_LOG_LEVEL 2
