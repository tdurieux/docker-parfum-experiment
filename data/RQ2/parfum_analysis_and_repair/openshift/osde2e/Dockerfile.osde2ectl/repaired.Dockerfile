FROM registry.ci.openshift.org/openshift/release:golang-1.16

ENV GOFLAGS=
ENV PKG=/go/src/github.com/openshift/osde2e/
WORKDIR ${PKG}

COPY . .
RUN go env
RUN make check
RUN make build

FROM registry.access.redhat.com/ubi7/ubi-minimal:latest

RUN mkdir /osde2e-bin
COPY --from=0 /go/src/github.com/openshift/osde2e/out/osde2ectl /osde2e-bin

# Restore the /osde2e path for backwards compatibility
ENV PATH "/osde2e-bin:$PATH"

ENTRYPOINT [ "osde2ectl" ]