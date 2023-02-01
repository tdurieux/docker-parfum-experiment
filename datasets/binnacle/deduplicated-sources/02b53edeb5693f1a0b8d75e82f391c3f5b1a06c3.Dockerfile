ARG RUNTIME_IMAGE=gcr.io/linkerd-io/base:2019-02-19.01

FROM gcr.io/linkerd-io/base:2019-02-19.01 as fetch
RUN apt-get update && apt-get install -y ca-certificates
WORKDIR /build
COPY bin/fetch-proxy bin/fetch-proxy
ARG PROXY_VERSION
RUN (proxy=$(bin/fetch-proxy $PROXY_VERSION) && \
    version=$(basename "$proxy" | sed 's/linkerd2-proxy-//') && \
    mv "$proxy" linkerd2-proxy && \
    echo "$version" >version.txt)

## compile proxy-identity agent
FROM gcr.io/linkerd-io/go-deps:b3c7654e as golang
WORKDIR /go/src/github.com/linkerd/linkerd2
ENV CGO_ENABLED=0 GOOS=linux
COPY pkg/flags pkg/flags
COPY pkg/tls pkg/tls
COPY pkg/version pkg/version
RUN go build ./pkg/...
COPY proxy-identity proxy-identity
RUN CGO_ENABLED=0 GOOS=linux go install ./proxy-identity

FROM $RUNTIME_IMAGE as runtime
COPY --from=fetch /build/target/proxy/LICENSE /usr/lib/linkerd/LICENSE
COPY --from=fetch /build/version.txt /usr/lib/linkerd/linkerd2-proxy-version.txt
COPY --from=fetch /build/linkerd2-proxy /usr/lib/linkerd/linkerd2-proxy
COPY --from=golang /go/bin/proxy-identity /usr/lib/linkerd/linkerd2-proxy-identity
COPY proxy-identity/run-proxy.sh /usr/bin/linkerd2-proxy-run
ARG LINKERD_VERSION
ENV LINKERD_CONTAINER_VERSION_OVERRIDE=${LINKERD_VERSION}
ENV LINKERD2_PROXY_LOG=warn,linkerd2_proxy=info
ENTRYPOINT ["/usr/bin/linkerd2-proxy-run"]
