FROM ubuntu:xenial AS base
RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository -y ppa:aziotsdklinux/ppa-azureiot && \
    apt-get update && \
    apt-get install --no-install-recommends -y azure-iot-sdk-c-dev && \
    rm -rf /var/lib/apt/lists/*

FROM base AS build-env
RUN apt-get update && \
    apt-get install -y --no-install-recommends cmake gcc g++ make && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY . ./
RUN ./scripts/linux/build.sh

FROM base
WORKDIR /app
COPY --from=build-env /app ./
RUN useradd -ms /bin/bash moduleuser
USER moduleuser
ENV IOTHUB_DEVICE_CONNECTION_STRING="<ADD CONNECTION STRING HERE>"
CMD ["./cmake/pnpbridge_linux/src/pnpbridge/module/pnpbridge_module"]