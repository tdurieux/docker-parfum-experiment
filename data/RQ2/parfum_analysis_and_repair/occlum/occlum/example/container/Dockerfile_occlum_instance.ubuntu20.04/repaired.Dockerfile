FROM ubuntu:20.04
LABEL maintainer="Qi Zheng <huaiqing.zq@antgroup.com>"

# Install SGX DCAP and Occlum runtime
ARG PSW_VERSION=2.15.101.1
ARG DCAP_VERSION=1.12.101.1
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
RUN apt update && DEBIAN_FRONTEND="noninteractive" apt install -y --no-install-recommends gnupg wget ca-certificates jq && \
    echo 'deb [arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu focal main' | tee /etc/apt/sources.list.d/intel-sgx.list && \
    wget -qO - https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | apt-key add - && \
    echo 'deb [arch=amd64] https://occlum.io/occlum-package-repos/debian focal main' | tee /etc/apt/sources.list.d/occlum.list && \
    wget -qO - https://occlum.io/occlum-package-repos/debian/public.key | apt-key add - && \
    apt update && \
    apt install --no-install-recommends -y libsgx-uae-service=$PSW_VERSION-focal1 && \
    apt install --no-install-recommends -y libsgx-dcap-ql=$DCAP_VERSION-focal1 && \
    apt install --no-install-recommends -y libsgx-dcap-default-qpl=$DCAP_VERSION-focal1 && \
    apt install --no-install-recommends -y occlum-runtime && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
ENV PATH="/opt/occlum/build/bin:/usr/local/occlum/bin:$PATH"

# Users need build their own applications and generate occlum package first.
ARG OCCLUM_PACKAGE
ADD $OCCLUM_PACKAGE /
COPY container/docker-entrypoint.sh /usr/local/bin/

ENV PCCS_URL="https://localhost:8081/sgx/certification/v3/"

ENTRYPOINT ["docker-entrypoint.sh"]
WORKDIR /occlum_instance
