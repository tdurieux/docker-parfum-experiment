FROM ubuntu:18.04
LABEL maintainer="djungelorm <djungelorm@users.noreply.github.com>"

ARG bazel_version
ARG ksp_version

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl ca-certificates gnupg git && \
    rm -rf /var/lib/apt/lists/*

# Install Bazel
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    pkg-config zip g++ zlib1g-dev unzip python3 wget && \
    echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | \
      tee /etc/apt/sources.list.d/bazel.list && \
    curl -f https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
    apt-get update && \
    apt-get install -y --no-install-recommends openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://github.com/bazelbuild/bazel/releases/download/${bazel_version}/bazel-${bazel_version}-installer-linux-x86_64.sh && \
    chmod +x bazel-${bazel_version}-installer-linux-x86_64.sh && \
    ./bazel-${bazel_version}-installer-linux-x86_64.sh && \
    rm bazel-${bazel_version}-installer-linux-x86_64.sh
# Note: uses Bazel installer rather than apt to avoid pulling in python2 dependencies
#       and because apt package of the specified version may not be available
#       if a new Bazel release has been made since. Use the following to install via apt:
# apt-get install -y --no-install-recommends bazel=${bazel_version} && \

# Install Mono
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
      --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | \
      tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y mono-devel && \
    rm -rf /var/lib/apt/lists/*

# Set up KSP libs
WORKDIR /usr/local/lib/ksp-${ksp_version}
RUN apt-get update && \
    apt-get install --no-install-recommends -y wget && \
    rm -rf /var/lib/apt/lists/* && \
    wget https://s3.amazonaws.com/krpc/lib/ksp-${ksp_version}.tar.gz && \
    tar -xf ksp-${ksp_version}.tar.gz && \
    ln -s /usr/local/lib/ksp-${ksp_version} /usr/local/lib/ksp && \
    rm /usr/local/lib/ksp-${ksp_version}/ksp-${ksp_version}.tar.gz

# Install kRPC build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3-setuptools python3-virtualenv \
    python3-dev autoconf libtool luarocks latexmk maven texlive-latex-base \
    texlive-latex-recommended texlive-fonts-recommended texlive-latex-extra \
    libxml2-dev libxslt1-dev librsvg2-bin && \
    rm -rf /var/lib/apt/lists/*

# Install kRPC test dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    virtualenv automake python3-pip python-pip python-setuptools \
    python-virtualenv python python-dev  \
    libenchant1c2a socat cmake && \
    rm -rf /var/lib/apt/lists/*

# Install gosu
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    sudo gosu && \
    rm -rf /var/lib/apt/lists/*

# Configure Bazel
COPY bazelrc /etc/bazel.bazelrc
RUN chmod 0644 /etc/bazel.bazelrc

# Set up user and home dir
RUN user_id=1000 && \
    addgroup -q --gid $user_id build && \
    adduser -q --system --uid $user_id --home /build --disabled-password --ingroup build build
USER build
WORKDIR /build

# Cache Bazel workspace dependencies and external build artifacts
COPY krpc.tar /build/krpc.tar
RUN mkdir krpc && \
    cd krpc && \
    tar -xf ../krpc.tar && \
    rm ../krpc.tar && \
    bazel fetch //... && \
    bazel build \
      @com_google_protobuf//:protobuf \
      @cpp_googletest//:gtest \
      @cpp_googletest//:gmock && \
    cd .. && \
    rm -rf krpc

# Set up entry point
USER root
RUN deluser build
WORKDIR /
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
