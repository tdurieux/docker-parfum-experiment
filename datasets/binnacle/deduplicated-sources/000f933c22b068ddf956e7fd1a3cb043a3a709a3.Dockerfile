## compile binaries
FROM gcr.io/linkerd-io/go-deps:b3c7654e as golang
WORKDIR /go/src/github.com/linkerd/linkerd2
COPY cli cli
COPY chart chart
COPY controller/k8s controller/k8s
COPY controller/api controller/api
COPY controller/gen controller/gen
COPY pkg pkg
RUN mkdir -p /out

# Generate static templates
RUN go generate ./cli

# Cache builds without version info
RUN CGO_ENABLED=0 GOOS=darwin  go build -o /out/linkerd-darwin  -tags prod -ldflags "-s -w" ./cli
RUN CGO_ENABLED=0 GOOS=linux   go build -o /out/linkerd-linux   -tags prod -ldflags "-s -w" ./cli
RUN CGO_ENABLED=0 GOOS=windows go build -o /out/linkerd-windows -tags prod -ldflags "-s -w" ./cli

ARG LINKERD_VERSION
ENV GO_LDFLAGS="-s -w -X github.com/linkerd/linkerd2/pkg/version.Version=${LINKERD_VERSION}"
RUN CGO_ENABLED=0 GOOS=darwin  go build -o /out/linkerd-darwin  -tags prod -ldflags "${GO_LDFLAGS}" ./cli
RUN CGO_ENABLED=0 GOOS=linux   go build -o /out/linkerd-linux   -tags prod -ldflags "${GO_LDFLAGS}" ./cli
RUN CGO_ENABLED=0 GOOS=windows go build -o /out/linkerd-windows -tags prod -ldflags "${GO_LDFLAGS}" ./cli

## export without sources & dependencies
FROM scratch
COPY LICENSE /linkerd/LICENSE
COPY --from=golang /out /out
# `ENTRYPOINT` prevents `docker build` from otherwise failing with "Error
# response from daemon: No command specified."
ENTRYPOINT ["/out/linkerd-linux"]
