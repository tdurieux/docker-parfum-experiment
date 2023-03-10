# This file describes the standard way to build Docker, using docker
#
# Usage:
#
# # Assemble the full dev environment. This is slow the first time.
# docker build -t docker -f Dockerfile.gccgo .
#

FROM gcc:5.3

# Packaged dependencies
RUN apt-get update && apt-get install -y \
	apparmor \
	aufs-tools \
	btrfs-tools \
	build-essential \
	curl \
	git \
	iptables \
	jq \
	net-tools \
	libapparmor-dev \
	libcap-dev \
	libsqlite3-dev \
	mercurial \
	parallel \
	python-dev \
	python-mock \
	python-pip \
	python-websocket \
	--no-install-recommends && rm -rf /var/lib/apt/lists/*;

# Get lvm2 source for compiling statically
RUN git clone -b v2_02_103 https://git.fedorahosted.org/git/lvm2.git /usr/local/lvm2
# see https://git.fedorahosted.org/cgit/lvm2.git/refs/tags for release tags

# Compile and install lvm2
RUN cd /usr/local/lvm2 \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-static_link \
	&& make device-mapper \
	&& make install_device-mapper
# see https://git.fedorahosted.org/cgit/lvm2.git/tree/INSTALL

# install seccomp: the version shipped in jessie is too old
ENV SECCOMP_VERSION v2.2.3
RUN set -x \
    && export SECCOMP_PATH=$(mktemp -d) \
    && git clone https://github.com/seccomp/libseccomp.git "$SECCOMP_PATH" \
    && ( cd "$SECCOMP_PATH" \
        && git checkout "$SECCOMP_VERSION" \
        && ./autogen.sh \
        && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr \
        && make \
        && make install) \

    && rm -rf "$SECCOMP_PATH"

ENV GOPATH /go:/go/src/github.com/docker/docker/vendor

# Get the "docker-py" source so we can run their integration tests
ENV DOCKER_PY_COMMIT e2878cbcc3a7eef99917adc1be252800b0e41ece
RUN git clone https://github.com/docker/docker-py.git /docker-py \
	&& cd /docker-py \
	&& git checkout -q $DOCKER_PY_COMMIT

# Add an unprivileged user to be used for tests which need it
RUN groupadd -r docker
RUN useradd --create-home --gid docker unprivilegeduser

VOLUME /var/lib/docker
WORKDIR /go/src/github.com/docker/docker
ENV DOCKER_BUILDTAGS apparmor seccomp selinux

# Wrap all commands in the "docker-in-docker" script to allow nested containers
ENTRYPOINT ["hack/dind"]

# Upload docker source
COPY . /go/src/github.com/docker/docker
