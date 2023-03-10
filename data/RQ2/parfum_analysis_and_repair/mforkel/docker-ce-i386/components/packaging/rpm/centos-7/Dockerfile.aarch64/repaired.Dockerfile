FROM arm64v8/centos:7
RUN yum groupinstall -y "Development Tools"
RUN yum -y swap -- remove systemd-container systemd-container-libs -- install systemd systemd-libs
RUN yum install -y \
   glibc-static \
   btrfs-progs-devel \
   device-mapper-devel \
   libseccomp-devel \
   libselinux-devel \
   libtool-ltdl-devel \
   selinux-policy-devel \
   systemd-devel \
   pkgconfig \
   tar \
   git \
   cmake \
   rpmdevtools \
   vim-common && rm -rf /var/cache/yum

ENV GO_VERSION 1.9.4
ENV DISTRO centos
ENV SUITE 7
RUN curl -fSL "https://golang.org/dl/go${GO_VERSION}.linux-arm64.tar.gz" | tar xzC /usr/local
RUN mkdir -p /go
ENV GOPATH=/go
ENV PATH $PATH:/usr/local/go/bin:/go/bin
ENV AUTO_GOPATH 1
ENV DOCKER_BUILDTAGS pkcs11 seccomp selinux
ENV RUNC_BUILDTAGS seccomp selinux
RUN mkdir -p /go/src/github.com/docker && mkdir -p /go/src/github.com/opencontainers
COPY docker-ce.spec /root/rpmbuild/SPECS/docker-ce.spec
WORKDIR /root/rpmbuild
ENTRYPOINT ["/bin/rpmbuild"]
