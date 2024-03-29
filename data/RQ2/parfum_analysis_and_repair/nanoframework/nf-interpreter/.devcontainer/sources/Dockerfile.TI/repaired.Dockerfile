FROM ghcr.io/linuxcontainers/debian-slim:latest AS downloader
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils \
    && apt-get install --no-install-recommends -y \
    curl \
    bzip2 \
    unzip && rm -rf /var/lib/apt/lists/*;

ARG GCC_URI=https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2
RUN mkdir -p /tmp/dc-downloads /tmp/dc-extracted/gcc /tmp/dc-extracted/cmake \
    && curl -f -o /tmp/dc-downloads/gcc-arm.tar.bz2 $GCC_URI \
    && bunzip2 -d /tmp/dc-downloads/gcc-arm.tar.bz2 \
    && tar -xvf /tmp/dc-downloads/gcc-arm.tar -C /tmp/dc-extracted/gcc --strip-components 1 \
    && rm -rf /tmp/dc-extracted/gcc/share/doc/ /tmp/dc-extracted/gcc/share/gcc-arm-none-eabi/samples/ && rm /tmp/dc-downloads/gcc-arm.tar

ARG CMAKE_SCRIPT=https://cmake.org/files/v3.23/cmake-3.23.0-linux-x86_64.sh
RUN curl -f -o /tmp/dc-downloads/cmake.sh $CMAKE_SCRIPT \
    && chmod +x /tmp/dc-downloads/cmake.sh \
    && bash /tmp/dc-downloads/cmake.sh --skip-license --prefix=/tmp/dc-extracted/cmake

# This is TI XDC tools for linux. Cheack all versions here: http://software-dl.ti.com/dsps/dsps_public_sw/sdo_sb/targetcontent/rtsc/index.html
ARG TI_TOOL_URL=http://software-dl.ti.com/dsps/dsps_public_sw/sdo_sb/targetcontent/rtsc/3_62_00_08/exports/xdccore/xdctools_3_62_00_08_core_linux.zip
RUN mkdir -p /tmp/dc-extracted/titools \
    && curl -f -o /tmp/dc-downloads/titools.zip $TI_TOOL_URL -L \
    && unzip -d /tmp/dc-extracted/titools /tmp/dc-downloads/titools.zip

FROM ghcr.io/linuxcontainers/debian-slim:latest AS devcontainer

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# You can set up non-root user
# ARG USERNAME=vscode
# ARG USER_UID=1000
# ARG USER_GID=$USER_UID

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog icu-devtools 2>&1 \
    && apt-get install --no-install-recommends -y \
    git \
    curl \
    ninja-build \
    srecord \
    nodejs && rm -rf /var/lib/apt/lists/*;

# Create needed directories
RUN mkdir -p /usr/local/bin/gcc \
    && mkdir -p /usr/local/bin/titools

# Clone what is needed for TI
RUN git clone --branch 4.10.00.07 https://github.com/nanoframework/SimpleLink_CC32xx_SDK.git --depth 1 ./sources/SimpleLinkCC32 \
    # you can't use the nanoFramework repository as it's Windows only
    # && git clone --branch 3.61.00.16 https://github.com/nanoframework/TI_XDCTools.git --depth 1 ./sources/TI_XDCTools \
    && git clone --branch 5.40.00.40 https://github.com/nanoframework/SimpleLink_CC13xx_26xx_SDK.git --depth 1 ./sources/SimpleLinkCC13 \
    && git clone --branch 1.10.0 https://github.com/nanoframework/TI_SysConfig.git --depth 1 ./sources/TI_SysConfig \
    && chmod +x ./sources/TI_SysConfig/sysconfig_cli.sh

# set gcc location
ENV ARM_GCC_PATH=/usr/local/bin/gcc
ENV PATH=$ARM_GCC_PATH/bin:${PATH}

# Copy from our other container
COPY --from=downloader /tmp/dc-extracted/gcc $ARM_GCC_PATH
COPY --from=downloader /tmp/dc-extracted/cmake /usr
COPY --from=downloader /tmp/dc-extracted/titools/xdctools_3_62_00_08_core /usr/local/bin/titools
# COPY ./scripts/git-pull-repos.sh /usr/local/git-pull-repos.sh

# Clean up downloaded files
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
