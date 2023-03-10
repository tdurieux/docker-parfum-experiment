FROM openshift/origin-release:golang-1.13 as builder
WORKDIR /go/src/github.com/tnozicka/openshift-acme
COPY . .
RUN make build --warn-undefined-variables

FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
COPY --from=builder /go/src/github.com/tnozicka/openshift-acme/openshift-acme-exposer /usr/bin/openshift-acme-exposer
ENTRYPOINT ["/usr/bin/openshift-acme-exposer"]