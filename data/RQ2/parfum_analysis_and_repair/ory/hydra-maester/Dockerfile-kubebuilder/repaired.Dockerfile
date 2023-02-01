FROM golang:1.16 as builder
WORKDIR /go/src/app
RUN os=$(go env GOOS) &&\
    arch=$(go env GOARCH) && \
    curl -f -sL https://github.com/kubernetes-sigs/kubebuilder/releases/download/v2.3.2/kubebuilder_2.3.2_${os}_${arch}.tar.gz | tar -xz -C /tmp/ && \
    mv /tmp/kubebuilder_2.3.2_${os}_${arch} /usr/local/kubebuilder && \
    export PATH=$PATH:/usr/local/kubebuilder/bin
COPY . .
RUN make test &&\
    make manager

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/static:latest
COPY --from=builder /go/src/app/manager .
USER 1000
ENTRYPOINT ["/manager"]
