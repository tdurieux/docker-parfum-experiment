FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.15-openshift-4.8 AS builder
WORKDIR /go/src/github.com/openshift/hello-openshift
COPY examples/hello-openshift .
RUN go build -o /hello-openshift

FROM registry.ci.openshift.org/ocp/4.8:base
COPY --from=builder /hello-openshift /hello-openshift
EXPOSE 8080 8888
USER 1001
ENTRYPOINT ["/hello-openshift"]