FROM debian:bullseye-slim

RUN apt-get update && \
  apt-get -y --no-install-recommends install wget tar unzip make clang-format gcc-arm-none-eabi && rm -rf /var/lib/apt/lists/*;

RUN cd /opt && \
  wget https://www.nordicsemi.com/-/media/Software-and-other-downloads/SDKs/nRF5/Binaries/nRF5SDK1702d674dde.zip -O nRF5_SDK.zip && \
  unzip nRF5_SDK.zip && \
  mv nRF5_SDK_17.0.2_d674dde nRF5_SDK

COPY build.sh /build.sh

ENTRYPOINT ["/build.sh"]