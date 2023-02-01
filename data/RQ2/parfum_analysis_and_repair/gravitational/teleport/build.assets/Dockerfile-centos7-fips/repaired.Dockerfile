FROM centos:7 AS libbpf

# Install required dependencies.
RUN yum groupinstall -y 'Development Tools' && \
    yum install -y epel-release && \
    yum update -y && \
    yum -y install centos-release-scl-rh && \
    yum install -y \
    # required by libbpf
    centos-release-scl \
    # required by libbpf
    devtoolset-11-gcc* \
    # required by libbpf
    devtoolset-11-make \
    # required by libbpf
    elfutils-libelf-devel-static \
    git \
    # required by libbpf
    scl-utils \
    yum clean all && rm -rf /var/cache/yum

# Install libbpf - compile with a newer GCC. The one installed by default is not able to compile it.
# BUILD_STATIC_ONLY disables libbpf.so build as we don't need it.
ARG LIBBPF_VERSION
RUN mkdir -p /opt && cd /opt && \
    curl -f -L https://github.com/gravitational/libbpf/archive/refs/tags/v${LIBBPF_VERSION}.tar.gz | tar xz && \
    cd /opt/libbpf-${LIBBPF_VERSION}/src && \
    scl enable devtoolset-11 "make && BUILD_STATIC_ONLY=y DESTDIR=/opt/libbpf make install"

FROM centos:7

ENV LANGUAGE=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LC_CTYPE=en_US.UTF-8

ARG BORINGCRYPTO_RUNTIME
ARG GO_BOOTSTRAP_RUNTIME=go1.9.7

ARG UID
ARG GID
RUN (groupadd ci --gid=$GID -o && useradd ci --uid=$UID --gid=$GID --create-home --shell=/bin/sh && \
     mkdir -p -m0700 /var/lib/teleport && chown -R ci /var/lib/teleport)

RUN yum groupinstall -y 'Development Tools' && \
    yum install -y epel-release && \
    yum update -y && \
    yum -y install centos-release-scl-rh && \
    yum install -y \
    #required by libbpf
    centos-release-scl \
    # required by libbpf
    devtoolset-11-* \
    # required by libbpf
    elfutils-libelf-devel-static \
    git \
    net-tools \
    # required by Teleport PAM support
    pam-devel \
    perl-IPC-Cmd \
    tree \
    # used by our Makefile
    which \
    zip \
    # required by libbpf
    zlib-static && \
    yum clean all && rm -rf /var/cache/yum

# Install etcd.
RUN ( curl -f -L https://github.com/coreos/etcd/releases/download/v3.3.9/etcd-v3.3.9-linux-amd64.tar.gz | tar -xz && \
     cp etcd-v3.3.9-linux-amd64/etcd* /bin/)

# BoringCrypto (unlike regular Go) requires glibc 2.14, so we have to build from source.
# 1) Install older binary Go runtime for bootstrapping
# 2) Get source for the correct Go boringcrypto runtime and compile it with Go bootstrap runtime
# 3) Erase Go bootstrap runtime and create build directories
# 4) Print compiled Go version
RUN mkdir -p /go-bootstrap && cd /go-bootstrap && curl -f https://dl.google.com/go/${GO_BOOTSTRAP_RUNTIME}.linux-amd64.tar.gz | tar xz && \
    mkdir -p /opt && cd /opt && curl -f https://go-boringcrypto.storage.googleapis.com/${BORINGCRYPTO_RUNTIME}.src.tar.gz | tar xz && \
    cd /opt/go/src && GOROOT_BOOTSTRAP=/go-bootstrap/go ./make.bash && \
    rm -rf /go-bootstrap && \
    mkdir -p /go/src/github.com/gravitational/teleport && \
    chmod a+w /go && \
    chmod a+w /var/lib && \
    chmod a-w / && \
    /opt/go/bin/go version

ENV GOPATH="/go" \
    GOROOT="/opt/go" \
    PATH="/opt/llvm/bin:$PATH:/opt/go/bin:/go/bin:/go/src/github.com/gravitational/teleport/build"

# Install PAM module and policies for testing.
COPY pam/ /opt/pam_teleport/
RUN make -C /opt/pam_teleport install

RUN chmod a-w /

# Download pre-built CentOS 7 assets with clang needed to build BPF tools.
RUN cd / && curl -f -L https://s3.amazonaws.com/clientbuilds.gravitational.io/go/centos7-assets.tar.gz | tar -xz

# Copy libbpf into the final image.
COPY --from=libbpf /opt/libbpf/usr /usr

USER ci
VOLUME ["/go/src/github.com/gravitational/teleport"]
EXPOSE 6600 2379 2380
