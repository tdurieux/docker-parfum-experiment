FROM registry.centos.org/centos/centos:7

RUN yum -y install btrfs-progs-devel \
              atomic-registries \
              bzip2 \
              device-mapper-devel \
              findutils \
              git \
              glibc-static \
              glib2-devel \
              gnupg \
              golang \
              golang-github-cpuguy83-go-md2man \
              gpgme-devel \
              libassuan-devel \
              libseccomp-devel \
              libselinux-devel \
              containers-common \
              runc \
              make \
              ostree-devel \
              lsof \
              which\
              golang-github-cpuguy83-go-md2man \
              nmap-ncat \
              xz \
              iptables && yum clean all

# Install CNI plugins
ENV CNI_COMMIT 7480240de9749f9a0a5c8614b17f1f03e0c06ab9
RUN set -x \
       && export GOPATH="$(mktemp -d)" \
       && git clone https://github.com/containernetworking/plugins.git "$GOPATH/src/github.com/containernetworking/plugins" \
       && cd "$GOPATH/src/github.com/containernetworking/plugins" \
       && git checkout -q "$CNI_COMMIT" \
       && ./build.sh \
       && mkdir -p /usr/libexec/cni \
       && cp bin/* /usr/libexec/cni \
       && rm -rf "$GOPATH"

# Install ginkgo
RUN set -x \
       && export GOPATH=/go \
       && go get -u github.com/onsi/ginkgo/ginkgo \
       && install -D -m 755 "$GOPATH"/bin/ginkgo /usr/bin/

# Install gomega
RUN set -x \
       && export GOPATH=/go \
       && go get github.com/onsi/gomega/...

# Install conmon
ENV CONMON_COMMIT 3e47d8dd45cdd973dbe256292d5e9c0bff195e56
RUN set -x \
	&& export GOPATH="$(mktemp -d)" \
	&& git clone https://github.com/containers/conmon.git "$GOPATH/src/github.com/containers/conmon.git" \
	&& cd "$GOPATH/src/github.com/containers/conmon.git" \
	&& git fetch origin --tags \
	&& git checkout -q "$CONMON_COMMIT" \
	&& make \
	&& install -D -m 755 bin/conmon /usr/libexec/podman/conmon \
	&& rm -rf "$GOPATH"

# Install cni config
#RUN make install.cni
RUN mkdir -p /etc/cni/net.d/
COPY cni/87-podman-bridge.conflist /etc/cni/net.d/87-podman-bridge.conflist

# Make sure we have some policy for pulling images
RUN mkdir -p /etc/containers
COPY test/policy.json /etc/containers/policy.json
COPY test/redhat_sigstore.yaml /etc/containers/registries.d/registry.access.redhat.com.yaml

WORKDIR /go/src/github.com/containers/libpod
