FROM arm64v8/fedora:27
RUN dnf -y upgrade
RUN dnf install -y @development-tools fedora-packager
RUN dnf install -y btrfs-progs-devel device-mapper-devel glibc-static libseccomp-devel libselinux-devel libtool-ltdl-devel pkgconfig selinux-policy selinux-policy-devel systemd-devel tar git cmake vim-common
ENV GO_VERSION 1.9.4
ENV DISTRO fedora
ENV SUITE 27
RUN curl -fSL "https://golang.org/dl/go${GO_VERSION}.linux-arm64.tar.gz" | tar xzC /usr/local
ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
ENV AUTO_GOPATH 1
ENV DOCKER_BUILDTAGS pkcs11 seccomp selinux
ENV RUNC_BUILDTAGS seccomp selinux
RUN mkdir -p /go/src/github.com/docker && mkdir -p /go/src/github.com/opencontainers
COPY docker-ce.spec /root/rpmbuild/SPECS/docker-ce.spec
WORKDIR /root/rpmbuild
ENTRYPOINT ["/bin/rpmbuild"]