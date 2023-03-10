ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG GOROOT=/usr/local/go
ARG GOARCH

ENV GOPATH=/go \
 GOROOT=${GOROOT} \
 GO111MODULE=on \
 PATH="${GOROOT}/bin:${GOPATH}/bin:${PATH}"

COPY build.env /

RUN source /build.env \
    && \
    ( test -n "${GOARCH}" && exit 0; echo -e "\n\nMissing GOARCH argument for building image, install Golang or run: make containerized-build GOARCH=amd64\n\n"; exit 1 ) \
    && mkdir -p /usr/local/go \
    && curl -f https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-${GOARCH}.tar.gz | tar xzf - -C ${GOROOT} --strip-components=1

# FIXME: Ceph does not need Apache Arrow anymore, some container images may
# still have the repository enabled. Disabling the repository can be removed in
# the future, see https://github.com/ceph/ceph-container/pull/1990 .
RUN dnf config-manager --disable apache-arrow-centos || true

RUN dnf -y install \
	git \
	make \
	gcc \
	librados-devel \
	librbd-devel \
    && dnf -y update \
    && dnf clean all \
    && rm -rf /var/cache/yum \
    && true

WORKDIR "/go/src/github.com/ceph/ceph-csi"
