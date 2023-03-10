ARG GO_IMAGE
ARG BUILD_IMAGE=mirantiseng/rhel:8
FROM ${GO_IMAGE} as golang

FROM ${BUILD_IMAGE}
ENV DISTRO rhel
ENV SUITE 8
ENV GOPATH=/go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
ENV AUTO_GOPATH 1
RUN yum install -y rpm-build rpmlint yum-utils redhat-rpm-config && rm -rf /var/cache/yum
COPY SPECS /root/rpmbuild/SPECS
RUN yum-builddep -y /root/rpmbuild/SPECS/docker-ee.spec
RUN yum-builddep -y /root/rpmbuild/SPECS/docker-ee-cli.spec
COPY --from=golang /usr/local/go /usr/local/go/
ENV DOCKER_BUILDTAGS seccomp selinux exclude_graphdriver_btrfs
ENV RUNC_BUILDTAGS seccomp selinux
WORKDIR /root/rpmbuild
ENTRYPOINT ["/bin/rpmbuild"]
