FROM ubuntu:trusty

ARG http_proxy
RUN env http_proxy=${http_proxy} apt-get update \
    && apt-get install --no-install-recommends -y build-essential libapt-pkg-dev curl && rm -rf /var/lib/apt/lists/*;

COPY uprust.sh /root/uprust.sh

RUN bash /root/uprust.sh --default-toolchain nightly -y

WORKDIR /mnt
