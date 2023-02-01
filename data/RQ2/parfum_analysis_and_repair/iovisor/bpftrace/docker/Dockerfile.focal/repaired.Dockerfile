FROM ubuntu:focal

ARG LLVM_VERSION
ENV LLVM_VERSION=$LLVM_VERSION

RUN apt-get update && apt-get install --no-install-recommends -y curl gnupg && \
    llvmRepository="\n\
deb http://apt.llvm.org/focal/ llvm-toolchain-focal main\n\
deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal main\n\
deb http://apt.llvm.org/focal/ llvm-toolchain-focal-${LLVM_VERSION} main\n\
deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal-${LLVM_VERSION} main\n" && \
    echo $llvmRepository >> /etc/apt/sources.list && \
    curl -f -L https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4052245BD4284CDD && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L --output /tmp/cmake.tar.gz \
  https://github.com/Kitware/CMake/releases/download/v3.20.0/cmake-3.20.0-linux-x86_64.tar.gz \
  && tar -xf /tmp/cmake.tar.gz -C /usr/local/ --strip-components=1 && rm /tmp/cmake.tar.gz

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
      make \
      pkg-config \
      asciidoctor \
      bison \
      binutils-dev \
      flex \
      g++ \
      git \
      libelf-dev \
      zlib1g-dev \
      libbpfcc-dev \
      libcereal-dev \
      libdw-dev \
      libpcap-dev \
      clang-${LLVM_VERSION} \
      libclang-${LLVM_VERSION}-dev \
      libclang-common-${LLVM_VERSION}-dev \
      libclang1-${LLVM_VERSION} \
      llvm-${LLVM_VERSION} \
      llvm-${LLVM_VERSION}-dev \
      llvm-${LLVM_VERSION}-runtime \
      libllvm${LLVM_VERSION} \
      systemtap-sdt-dev \
      python3 \
      xxd \
      libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN if [ "$LLVM_VERSION" -ge 13 ] ; then \
 apt-get install --no-install-recommends -y libmlir-${LLVM_VERSION}-dev; rm -rf /var/lib/apt/lists/*; fi

RUN ln -s /usr/bin/python3 /usr/bin/python
COPY build.sh /build.sh
RUN chmod 755 /build.sh
ENTRYPOINT ["bash", "/build.sh"]
