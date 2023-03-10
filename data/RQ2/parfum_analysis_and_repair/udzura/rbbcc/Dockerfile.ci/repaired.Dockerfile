# ref: https://github.com/iovisor/bcc/blob/master/Dockerfile.tests
FROM ubuntu:18.04

ENV LLVM_VERSION="9"

ARG BCC_VERSION="0.16.0"
ENV BCC_VERSION=$BCC_VERSION

ARG RUBY_VERSION="2.7.2"
ENV RUBY_VERSION=$RUBY_VERSION

ARG RUBY_VERSION_ARCHIVE="ruby-${RUBY_VERSION}.tar.bz2"
ENV RUBY_VERSION_ARCHIVE=$RUBY_VERSION_ARCHIVE

ARG RUBY_EXTRA_OPTS=""
ENV RUBY_EXTRA_OPTS=$RUBY_EXTRA_OPTS

ARG BCC_EXTRA_OPTS=""
ENV BCC_EXTRA_OPTS=$BCC_EXTRA_OPTS

RUN apt-get update && apt-get install --no-install-recommends -y curl gnupg && \
    llvmRepository="\n\
deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic main\n\
deb-src http://apt.llvm.org/bionic/ llvm-toolchain-bionic main\n\
deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-${LLVM_VERSION} main\n\
deb-src http://apt.llvm.org/bionic/ llvm-toolchain-bionic-${LLVM_VERSION} main\n" && \
    echo $llvmRepository >> /etc/apt/sources.list && \
    curl -f -L https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    apt-get update && apt-get install --no-install-recommends -y \
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
      iputils-ping \
      bridge-utils \
      libtinfo5 \
      libtinfo-dev && \
  wget -O ruby-install-0.7.1.tar.gz \
         https://github.com/postmodern/ruby-install/archive/v0.7.1.tar.gz && \
  tar -xzvf ruby-install-0.7.1.tar.gz && \
  cd ruby-install-0.7.1/ && \
  make install && \
  sed -i 's/^ruby_archive=.*/ruby_archive="${ruby_archive:-ruby-$ruby_version.tar.bz2}"/' /usr/local/share/ruby-install/ruby/functions.sh && \
  env ruby_archive=$RUBY_VERSION_ARCHIVE ruby-install --system $RUBY_EXTRA_OPTS ruby $RUBY_VERSION && \
  git config --global user.name 'udzura' && \
  git config --global user.email 'udzura@udzura.jp' && \
  wget -O bcc-$BCC_VERSION.tar.gz \
         https://github.com/iovisor/bcc/releases/download/v$BCC_VERSION/bcc-src-with-submodule.tar.gz && \
  tar -xzvf bcc-$BCC_VERSION.tar.gz && \
  cd bcc/ && \
  ( test "$BCC_VERSION" = "0.12.0" && curl -f https://github.com/iovisor/bcc/commit/977a7e3a568c4c929fabeb4a025528d9b6f1e84c.patch | patch -p1 || true) && \
  git init . && git add . && git commit -m 'Dummy' && git tag v$BCC_VERSION && \
  mkdir build && cd build/ && \
  cmake $BCC_EXTRA_OPTS -DCMAKE_BUILD_TYPE=Release .. && \
  cd src/cc && \
  make -j8 && make install && \
  cd ../.. && \
  apt-get remove --purge -y \
      binutils-dev \
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
      libtinfo-dev && \
   apt autoremove -y && \
   apt-get clean -y && \
   rm -rf *.tar.gz bcc/ && rm -rf /var/lib/apt/lists/*;
