ARG GO_IMAGE
FROM ${GO_IMAGE} as golang

FROM fedora:28
ENV DISTRO fedora
ENV SUITE 28
ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
ENV AUTO_GOPATH 1
ENV RUNC_BUILDTAGS seccomp selinux
RUN dnf install -y rpm-build rpmlint dnf-plugins-core
COPY SPECS /root/rpmbuild/SPECS
RUN dnf builddep -y /root/rpmbuild/SPECS/*.spec
COPY --from=golang /usr/local/go /usr/local/go/
WORKDIR /root/rpmbuild
ENTRYPOINT ["/bin/rpmbuild"]
