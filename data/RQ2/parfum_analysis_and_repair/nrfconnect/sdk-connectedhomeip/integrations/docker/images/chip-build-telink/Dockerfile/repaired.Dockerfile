ARG VERSION=latest
FROM connectedhomeip/chip-build:${VERSION} as build

RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -fy --no-install-recommends \
    wget=1.20.3-1ubuntu2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/ \
    && : && rm -rf /var/lib/apt/lists/*;

# Setup toolchain
RUN set -x \
    && wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.13.2/zephyr-toolchain-riscv64-0.13.2-linux-x86_64-setup.run -O /tmp/zephyr-toolchain-riscv64-setup.run \
    && chmod +x /tmp/zephyr-toolchain-riscv64-setup.run \
    && /tmp/zephyr-toolchain-riscv64-setup.run -- -d /opt/telink/zephyr-sdk-0.13.2 \
    && : # last line

# Setup Zephyr
ARG ZEPHYR_REVISION=148e7967fb6062555f69de8cbcdc997f826b241c
WORKDIR /opt/telink/zephyrproject
RUN set -x \
    && python3 -m pip install -U --no-cache-dir \
    west==0.12.0 \
    && git clone https://github.com/rikorsev/zephyr \
    && cd zephyr \
    && git reset ${ZEPHYR_REVISION} --hard \
    && west init -l \
    && cd .. \
    && west update -o=--depth=1 -n -f smart \
    && cd modules/hal/telink \
    && git remote add telink https://github.com/rikorsev/hal_telink \
    && git fetch telink telink_crypto \
    && git checkout telink_crypto \
    && west zephyr-export \
    && : # last line

FROM connectedhomeip/chip-build:${VERSION}

COPY --from=build /opt/telink/zephyr-sdk-0.13.2/ /opt/telink/zephyr-sdk-0.13.2/
COPY --from=build /opt/telink/zephyrproject/ /opt/telink/zephyrproject/

ENV ZEPHYR_TOOLCHAIN_VARIANT=zephyr
ENV ZEPHYR_SDK_INSTALL_DIR=/opt/telink/zephyr-sdk-0.13.2

RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -fy --no-install-recommends \
    ccache=3.7.7-1 \
    dfu-util=0.9-1 \
    device-tree-compiler=1.5.1-1 \
    gcc-multilib=4:9.3.0-1ubuntu2 \
    g++-multilib=4:9.3.0-1ubuntu2 \
    libsdl2-dev=2.0.10+dfsg1-3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/ \
    && python3 -m pip install -U --no-cache-dir \
    pyelftools==0.27 \
    && pip3 install --no-cache-dir --user -r /opt/telink/zephyrproject/zephyr/scripts/requirements.txt \
    && : && rm -rf /var/lib/apt/lists/*;

# Setup Telink tools required for "west flash"
ARG TELINK_TOOLS_BASE=/opt/telink/tools
RUN wget https://wiki.telink-semi.cn/tools_and_sdk/Tools/IDE/telink_riscv_ice_flash_tool.zip -O /opt/telink/tools.zip \
    && unzip /opt/telink/tools.zip -d ${TELINK_TOOLS_BASE} \
    && rm /opt/telink/tools.zip \
    && mv ${TELINK_TOOLS_BASE}/telink_riscv_linux_toolchain/* ${TELINK_TOOLS_BASE} \
    && rm -rf ${TELINK_TOOLS_BASE}/telink_riscv_linux_toolchain \
    && chmod +x ${TELINK_TOOLS_BASE}/flash/bin/SPI_burn \
    && chmod +x ${TELINK_TOOLS_BASE}/ice/ICEman \
    && :

# Add path to Telink tools
ENV PATH="${TELINK_TOOLS_BASE}/flash/bin:${PATH}"
ENV PATH="${TELINK_TOOLS_BASE}/ice:${PATH}"

ARG ZEPHYR_PROJECT_DIR=/opt/telink/zephyrproject
ENV TELINK_ZEPHYR_BASE=${ZEPHYR_PROJECT_DIR}/zephyr
ENV ZEPHYR_BASE=${ZEPHYR_PROJECT_DIR}/zephyr
