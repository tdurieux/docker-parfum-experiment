# devicedevex.azurecr.io/internal/iot-device-cube:1.0.0-alpine-arm64
FROM frolvlad/alpine-glibc

# Download toolchain
RUN mkdir -p /usr/xcc
WORKDIR /usr/xcc
RUN wget https://releases.linaro.org/components/toolchain/binaries/latest-7/aarch64-linux-gnu/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu.tar.xz && \
  tar xf gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu.tar.xz && \
  mv gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu aarch64-linux-gnu && \
  rm gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu.tar.xz

# Set ENV