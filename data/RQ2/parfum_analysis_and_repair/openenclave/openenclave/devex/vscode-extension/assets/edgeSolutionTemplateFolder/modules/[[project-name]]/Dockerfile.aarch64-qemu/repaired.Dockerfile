FROM amd64/ubuntu:xenial AS amd64-build-base
RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common gcc \
        gcc-aarch64-linux-gnu g++ g++-aarch64-linux-gnu make wget python-dev \
        python-pip libcurl3 libssl1.0.0 apt-transport-https && \
    rm -rf /var/lib/apt/lists/*

RUN echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ xenial main restricted" > /etc/apt/sources.list && \
    echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports xenial main restricted" >> /etc/apt/sources.list && \
    echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ xenial-updates main restricted" >> /etc/apt/sources.list && \
    echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports xenial-updates main restricted" >> /etc/apt/sources.list && \
    echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ xenial universe" >> /etc/apt/sources.list && \
    echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports xenial universe" >> /etc/apt/sources.list && \
    echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ xenial-updates universe" >> /etc/apt/sources.list && \
    echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports xenial-updates universe" >> /etc/apt/sources.list && \
    echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ xenial multiverse" >> /etc/apt/sources.list && \
    echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports xenial multiverse" >> /etc/apt/sources.list && \
    echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ xenial-updates multiverse" >> /etc/apt/sources.list && \
    echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports xenial-updates multiverse" >> /etc/apt/sources.list && \
    echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb [arch=amd64,i386] http://security.ubuntu.com/ubuntu/ xenial-security main restricted" >> /etc/apt/sources.list && \
    echo "deb [arch=amd64,i386] http://security.ubuntu.com/ubuntu/ xenial-security universe" >> /etc/apt/sources.list && \
    echo "deb [arch=amd64,i386] http://security.ubuntu.com/ubuntu/ xenial-security multiverse" >> /etc/apt/sources.list && \
    echo "deb [arch=arm64] http://ppa.launchpad.net/aziotsdklinux/ppa-azureiot/ubuntu xenial main" >> /etc/apt/sources.list && \
    echo "deb [arch=amd64] http://apt.llvm.org/xenial/ llvm-toolchain-xenial-7 main" >> /etc/apt/sources.list && \
    echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/16.04/prod xenial main" >> /etc/apt/sources.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AF1A6BA067E3641215DF0ECBFDA6A393E4C2257F && \
    wget -qO - https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | apt-key add - && \
    wget -qO - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    wget -qO - https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    dpkg --add-architecture arm64 && \
    apt-get update && \
    apt-get install --no-install-recommends -y azure-iot-sdk-c-dev:arm64 libcurl3:arm64 \
        libcurl3-dev:arm64 libssl1.0.0:arm64 libssl-dev:arm64 clang-10 \
        libssl-dev gdb libprotobuf9v5 && \
    rm -rf /var/lib/apt/lists/*

RUN wget -nv https://cmake.org/files/v3.14/cmake-3.14.2-Linux-x86_64.sh && \
    chmod +x cmake-3.14.2-Linux-x86_64.sh && \
    ./cmake-3.14.2-Linux-x86_64.sh --skip-license --prefix=/usr

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir setuptools
RUN pip install --no-cache-dir pycrypto

FROM amd64-build-base AS amd64-module
WORKDIR /app
COPY . ./
RUN cmake \
    -DOE_TEE=OP-TEE \
    -DOE_OPTEE_PLATFORM=QEMU-ARMv8 \
    -DCMAKE_TOOLCHAIN_FILE=/app/cmake/arm-cross.cmake \
    -DCMAKE_BUILD_TYPE=Debug \
    .
RUN make -j$(nproc)

FROM aarch64/ubuntu:xenial
RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository -y ppa:aziotsdklinux/ppa-azureiot && \
    apt-get update && \
    apt-get install --no-install-recommends -y azure-iot-sdk-c-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=amd64-module /app/out/ ./out/
CMD echo "Starting [[project-name]]" && \
    cp -f ./out/bin/[[generated-uuid]].ta /lib/optee_armtz/[[generated-uuid]].ta && \
    exec ./out/bin/[[project-name]]
