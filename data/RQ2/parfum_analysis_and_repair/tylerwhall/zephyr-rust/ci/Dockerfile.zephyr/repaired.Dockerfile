FROM ubuntu:20.04

# Prevent prompts configuring tzdata
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt-get update && apt-get install -y --no-install-recommends \
    git cmake ninja-build gperf \
    ccache dfu-util device-tree-compiler wget \
    python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
    make gcc gcc-multilib g++-multilib libsdl2-dev && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -U west

ARG SDK_VERSION=0.11.4
ARG SDK_URL=https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.12.2/zephyr-sdk-0.12.2-x86_64-linux-setup.run
RUN wget ${SDK_URL} -O ./zephyr-sdk.run && chmod +x ./zephyr-sdk.run
RUN ./zephyr-sdk.run -- -d /opt/zephyr-sdk-${SDK_VERSION} && rm ./zephyr-sdk.run
# Required for sanitycheck
ENV ZEPHYR_TOOLCHAIN_VARIANT=zephyr

ARG ZEPHYR_VERSION=2.4.0
ENV WEST_BASE=/zephyrproject
ENV ZEPHYR_BASE=${WEST_BASE}/zephyr
RUN west init ${WEST_BASE} --mr refs/tags/zephyr-v${ZEPHYR_VERSION}
WORKDIR ${WEST_BASE}
RUN west update

RUN pip3 install --no-cache-dir -r ${ZEPHYR_BASE}/scripts/requirements.txt
