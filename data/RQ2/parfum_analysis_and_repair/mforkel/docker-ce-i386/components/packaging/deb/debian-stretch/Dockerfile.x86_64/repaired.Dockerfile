FROM debian:stretch

# allow replacing httpredir or deb mirror
ARG APT_MIRROR=deb.debian.org
RUN sed -ri "s/(httpredir|deb).debian.org/$APT_MIRROR/g" /etc/apt/sources.list

RUN apt-get update && apt-get install -y apparmor bash-completion btrfs-tools build-essential cmake curl ca-certificates debhelper dh-apparmor dh-systemd git libapparmor-dev libdevmapper-dev libltdl-dev libseccomp-dev pkg-config vim-common libsystemd-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV GO_VERSION 1.9.4
RUN curl -fSL "https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz" | tar xzC /usr/local
ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
ENV DOCKER_BUILDTAGS apparmor pkcs11 seccomp selinux
ENV RUNC_BUILDTAGS apparmor seccomp selinux

COPY common/ /root/build-deb/debian
COPY build-deb /root/build-deb/build-deb

RUN mkdir -p /go/src/github.com/docker && \
	mkdir -p /go/src/github.com/opencontainers && \
	ln -snf /engine /root/build-deb/engine && \
	ln -snf /cli /root/build-deb/cli && \
	ln -snf /root/build-deb/engine /go/src/github.com/docker/docker && \
	ln -snf /root/build-deb/cli /go/src/github.com/docker/cli


ENV DISTRO debian
ENV SUITE stretch

WORKDIR /root/build-deb

ENTRYPOINT ["/root/build-deb/build-deb"]