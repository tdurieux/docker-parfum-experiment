FROM centos:7

# Version from build arguments
ARG VERSION

# Labels used by Docker
LABEL "io.istio.repo"="https://github.com/istio/tools"
LABEL "io.istio.version"="${VERSION}"

# hadolint ignore=DL3031,DL3033
RUN yum install -y centos-release-scl epel-release && \
    yum update -y && \
    yum install -y fedpkg sudo devtoolset-7-gcc devtoolset-7-gcc-c++ \
                   devtoolset-7-binutils java-1.8.0-openjdk-headless rsync \
                   rh-git218 wget unzip which make cmake3 patch ninja-build \
                   devtoolset-7-libatomic-devel openssl python27 libtool autoconf && \
    yum clean all && rm -rf /var/cache/yum

# Python dependencies
# hadolint ignore=DL3013
RUN pip3 install --no-cache-dir dataclasses

# Install bazel
RUN curl -f -o /usr/local/bin/bazel -L https://github.com/bazelbuild/bazelisk/releases/download/v1.9.0/bazelisk-linux-amd64 && \
    chmod +x /usr/local/bin/bazel

RUN ln -s /usr/bin/cmake3 /usr/bin/cmake

RUN echo "/opt/rh/httpd24/root/usr/lib64" > /etc/ld.so.conf.d/httpd24.conf && \
    ldconfig

# We need gsutil to push/pull
ADD https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-265.0.0-linux-x86_64.tar.gz /tmp
RUN tar -xzvf "/tmp/google-cloud-sdk-265.0.0-linux-x86_64.tar.gz" -C /usr/local && rm "/tmp/google-cloud-sdk-265.0.0-linux-x86_64.tar.gz"

# The folder `clang-toolchain` at the root of this repository can be used to build clang+llvm for centos.
ENV LLVM_RELEASE=clang+llvm-12.0.1-x86_64-linux-centos7
# hadolint ignore=DL4006
RUN curl -fsSL --output ${LLVM_RELEASE}.tar https://storage.googleapis.com/istio-build-deps/${LLVM_RELEASE}.tar && \
   tar -xf ${LLVM_RELEASE}.tar && \
   mv ./${LLVM_RELEASE} /opt/llvm && \
   chown -R root:root /opt/llvm && \
   rm ./${LLVM_RELEASE}.tar && \
   echo "/opt/llvm/lib" > /etc/ld.so.conf.d/llvm.conf && \
   ldconfig

ENV PATH=/opt/llvm/bin:/usr/local/google-cloud-sdk/bin:$PATH

# Sha matches DEPS in the root of the wee8 tar ball in envoy's repository_locations.bzl
# hadolint ignore=DL3003
RUN cd /tmp && git clone https://gn.googlesource.com/gn && cd gn && \
   git checkout 39a87c0b36310bdf06b692c098f199a0d97fc810 && \
   python build/gen.py && ninja -C out && cp out/gn /usr/bin && rm -rf /tmp/gn

ENV HOME=/home
