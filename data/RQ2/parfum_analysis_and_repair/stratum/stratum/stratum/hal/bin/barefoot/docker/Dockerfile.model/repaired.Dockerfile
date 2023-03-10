# Copyright 2012-present Open Networking Foundation
# SPDX-License-Identifier: Apache-2.0

FROM ubuntu:18.04 as extractor

ARG SDE_TAR_NAME
ARG SDE_VER

ADD ./${SDE_TAR_NAME} /

RUN mkdir -p /output/usr/local/bin
RUN tar -xzvf bf-sde-$SDE_VER/packages/tofino-model-$SDE_VER.tgz && rm bf-sde-$SDE_VER/packages/tofino-model-$SDE_VER.tgz
RUN tar -xzvf bf-sde-$SDE_VER/packages/ptf-modules-$SDE_VER.tgz && rm bf-sde-$SDE_VER/packages/ptf-modules-$SDE_VER.tgz
RUN cp tofino-model-$SDE_VER/tofino-model.x86_64.bin /output/usr/local/bin/tofino-model
RUN cp ptf-modules-$SDE_VER/ptf-utils/veth_setup.sh /output/usr/local/bin/
RUN cp ptf-modules-$SDE_VER/ptf-utils/dma_setup.sh /output/usr/local/bin/

FROM ubuntu:18.04
LABEL maintainer="Stratum dev <stratum-dev@lists.stratumproject.org>"
LABEL description="This Docker image includes the Barefoot Tofino model"

ENV BUILD_DEPS \
    iproute2 \
    ethtool \
    procps \
    libcli1.9
RUN apt-get update && \
    apt-get install --no-install-recommends -y $BUILD_DEPS && \
    rm -rf /var/lib/apt/lists/*

COPY --from=extractor /output /
ADD ./tofino_skip_p4.conf /usr/share/stratum/
ADD docker/start-tofino-model.sh /usr/local/bin/

EXPOSE 8000-8004/tcp

WORKDIR /var/run/tofino-model
ENTRYPOINT ["start-tofino-model.sh"]
