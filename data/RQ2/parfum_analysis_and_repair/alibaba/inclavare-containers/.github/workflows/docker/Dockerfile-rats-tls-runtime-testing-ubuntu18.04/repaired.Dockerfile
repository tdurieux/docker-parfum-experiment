FROM ubuntu:18.04

LABEL maintainer="Shirong Hao <shirong@linux.alibaba.com>"

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install --no-install-recommends -y wget gnupg && rm -rf /var/lib/apt/lists/*;

# install sgx
RUN echo "deb [arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu bionic main" | tee /etc/apt/sources.list.d/intel-sgx.list && \
    wget -qO - https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | apt-key add -

RUN apt-get update -y && apt-get install --no-install-recommends -y \
    libsgx-dcap-quote-verify libsgx-dcap-default-qpl libsgx-dcap-ql-dev libsgx-uae-service && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
