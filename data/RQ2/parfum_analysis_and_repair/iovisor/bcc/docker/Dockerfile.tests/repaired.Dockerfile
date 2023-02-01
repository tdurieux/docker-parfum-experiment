ARG UBUNTU_VERSION="18.04"
FROM ubuntu:${UBUNTU_VERSION}

ARG LLVM_VERSION="11"
ENV LLVM_VERSION=$LLVM_VERSION

ARG UBUNTU_SHORTNAME="bionic"

RUN apt-get update && apt-get install --no-install-recommends -y curl gnupg && \
    llvmRepository="\n\
deb http://apt.llvm.org/${UBUNTU_SHORTNAME}/ llvm-toolchain-${UBUNTU_SHORTNAME} main\n\
deb-src http://apt.llvm.org/${UBUNTU_SHORTNAME}/ llvm-toolchain-${UBUNTU_SHORTNAME} main\n\
deb http://apt.llvm.org/${UBUNTU_SHORTNAME}/ llvm-toolchain-${UBUNTU_SHORTNAME}-${LLVM_VERSION} main\n\
deb-src http://apt.llvm.org/${UBUNTU_SHORTNAME}/ llvm-toolchain-${UBUNTU_SHORTNAME}-${LLVM_VERSION} main\n" && \
    echo $llvmRepository >> /etc/apt/sources.list && \
    curl -f -L https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && rm -rf /var/lib/apt/lists/*;

ARG DEBIAN_FRONTEND="noninteractive"
ENV TZ="Etc/UTC"

RUN apt-get update && apt-get install --no-install-recommends -y \
      util-linux \
      bison \
      binutils-dev \
      cmake \
      flex \
      g++ \
      git \
      kmod \
      wget \
      libelf-dev \
      zlib1g-dev \
      libiberty-dev \
      libbfd-dev \
      libedit-dev \
      clang-${LLVM_VERSION} \
      libclang-${LLVM_VERSION}-dev \
      libclang-common-${LLVM_VERSION}-dev \
      libclang1-${LLVM_VERSION} \
      llvm-${LLVM_VERSION} \
      llvm-${LLVM_VERSION}-dev \
      llvm-${LLVM_VERSION}-runtime \
      libllvm${LLVM_VERSION} \
      systemtap-sdt-dev \
      sudo \
      iproute2 \
      python3 \
      python3-pip \
      ethtool \
      arping \
      netperf \
      iperf \
      iputils-ping \
      bridge-utils \
      libtinfo5 \
      libtinfo-dev && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir pyroute2==0.5.18 netaddr==0.8.0 dnslib==0.9.14 cachetools==3.1.1

# FIXME this is faster than building from source, but it seems there is a bug
# in probing libruby.so rather than ruby binary
#RUN apt-get update -qq && \
#    apt-get install -y software-properties-common && \
#    apt-add-repository ppa:brightbox/ruby-ng && \
#    apt-get update -qq && apt-get install -y ruby2.6 ruby2.6-dev

RUN wget -O ruby-install-0.7.0.tar.gz \
         https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz && \
    tar -xzvf ruby-install-0.7.0.tar.gz && \
    cd ruby-install-0.7.0/ && \
    make install && rm ruby-install-0.7.0.tar.gz

RUN ruby-install --system ruby 2.6.0 -- --enable-dtrace
RUN if [ ! -f "/usr/bin/python" ]; then ln -s /bin/python3 /usr/bin/python; fi
