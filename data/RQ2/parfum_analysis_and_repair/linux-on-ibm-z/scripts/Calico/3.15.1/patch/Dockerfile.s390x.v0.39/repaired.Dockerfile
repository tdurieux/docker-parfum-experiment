FROM calico/bpftool:v5.3-s390x as bpftool

FROM s390x/golang:1.13.7-buster

ARG QEMU_VERSION=4.2.0-6

# we need these two distinct lists. The first one is the names used by the qemu distributions
# these second is the names used by golang see https://github.com/golang/go/blob/master/src/go/build/syslist.go
# the primary difference as of this writing is that qemu uses aarch64 and golang uses arm64
ARG QEMU_ARCHS="aarch64 ppc64le s390x"
ARG CROSS_ARCHS="arm64 ppc64le s390x"

ARG MANIFEST_TOOL_VERSION=v1.0.2

# Install su-exec for use in the entrypoint.sh (so processes run as the right user)
# Install bash for the entry script (and because it's generally useful)
# Install curl to download glide
# Install git for fetching Go dependencies
# Install ssh for fetching Go dependencies
# Install mercurial for fetching go dependencies
# Install wget since it's useful for fetching
# Install make for building things
# Install util-linux for column command (used for output formatting).
# Install grep and sed for use in some Makefiles (e.g. pulling versions out of glide.yaml)
# Install gcc for cgo.
# Install clang, libbpf and newer kernel headers for building BPF binaries.
RUN echo 'APT::Default-Release "stable";' > /etc/apt/apt.conf.d/99defaultrelease && \
  echo 'deb     http://ftp.de.debian.org/debian/    buster-backports main contrib non-free' > /etc/apt/sources.list.d/buster-backports.list && \
  apt-get -y update &&  \
  apt-get -y upgrade && \
  apt-get install --no-install-recommends -y -t buster-backports \
  libbpf-dev linux-headers-s390x  && \
  apt-get install --no-install-recommends -y \
  curl bash git openssh-client mercurial make wget util-linux file grep sed \
  llvm clang binutils file iproute2 \
  ca-certificates gcc libc-dev bsdmainutils strace && \
  rm -rf /var/lib/apt/lists/*

# su-exec is used by the entrypoint script to execute the user's command with the right UID/GID.
# (sudo doesn't work easily in a container.)  The version was current master at the time of writing.
ARG SU_EXEC_VER=212b75144bbc06722fbd7661f651390dc47a43d1
RUN set -ex; \
  curl -f -o /sbin/su-exec.c https://raw.githubusercontent.com/ncopa/su-exec/${SU_EXEC_VER}/su-exec.c; \
  gcc -Wall /sbin/su-exec.c -o/sbin/su-exec; \
  chown root:root /sbin/su-exec; \
  chmod 0755 /sbin/su-exec; \
  rm /sbin/su-exec.c

# Disable ssh host key checking
RUN echo 'Host *' >> /etc/ssh/ssh_config \
  && echo '    StrictHostKeyChecking no' >> /etc/ssh/ssh_config

# We want to be able to do both cgo and non-cgo builds.  That's awkward because toggling cgo
# results in parts of the stdlib getting rebuilt (which fails due to the container's read-only
# filesystem).  As a workaround: take a copy of the go root for cgo builds and have the
# entrypoint script swap it into the path if it detects CGO_ENABLED=1.
ENV GOROOT=/usr/local/go
ENV GOCGO=/usr/local/go-cgo

# Disable cgo by default so that binaries we build will be fully static by default.
ENV CGO_ENABLED=0

RUN cp -a $GOROOT $GOCGO && \
  go install -v std && \
  rm -rf /go/src/* /root/.cache

# Install go programs that we rely on
ENV GLIDE_HOME /home/user/.glide
RUN go get github.com/Masterminds/glide && \
  go get github.com/golang/dep/cmd/dep && \
  go get github.com/onsi/ginkgo/ginkgo && \
  go get golang.org/x/tools/cmd/goimports && \
  wget -O - -q https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s v1.20.0 && \
  golangci-lint --version && \
  go get github.com/pmezard/licenses && \
  go get github.com/wadey/gocovmerge && \
  go get github.com/mikefarah/yaml && \
  go get -u golang.org/x/vgo && \
  go get -u github.com/jstemmer/go-junit-report && \
  go get -u golang.org/x/tools/cmd/stringer && \
  rm -rf /go/src/* /root/.cache

# Enable non-native runs on amd64 architecture hosts
RUN for i in ${QEMU_ARCHS}; do curl -f -L https://github.com/multiarch/qemu-user-static/releases/download/v${QEMU_VERSION}/qemu-${i}-static.tar.gz | tar zxvf - -C /usr/bin; done
RUN chmod +x /usr/bin/qemu-*

# When running cross built binaries run-times will be auto-installed,
# ensure the install directory is writable by everyone.
RUN for arch in ${CROSS_ARCHS}; do mkdir -m +w -p /usr/local/go/pkg/linux_${arch}; GOARCH=${arch} go install -v std; done

# Ensure that everything under the GOPATH is writable by everyone
RUN chmod -R 777 $GOPATH

RUN curl -f -sSL https://github.com/estesp/manifest-tool/releases/download/${MANIFEST_TOOL_VERSION}/manifest-tool-linux-amd64 > manifest-tool && \
  chmod +x manifest-tool && \
  mv manifest-tool /usr/bin/

# Add bpftool for Felix UT/FV.
COPY --from=bpftool /bpftool /usr/bin

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
