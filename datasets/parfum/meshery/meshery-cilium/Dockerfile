FROM golang:1.17 as build-env
ARG VERSION
ARG GIT_COMMITSHA

WORKDIR /github.com/meshery/meshery-cilium
COPY go.mod go.sum ./
RUN go mod download
COPY main.go main.go
COPY internal/ internal/
COPY cilium/ cilium/
COPY build/ build/
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -ldflags="-w -s -X main.version=$VERSION -X main.gitsha=$GIT_COMMITSHA" -a -o meshery-cilium main.go

FROM alpine:3.15 as jsonschema-util
RUN apk add --no-cache curl
WORKDIR /
RUN curl -LO https://github.com/layer5io/kubeopenapi-jsonschema/releases/download/v0.1.0/kubeopenapi-jsonschema
RUN chmod +x /kubeopenapi-jsonschema

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/nodejs:16
ENV DISTRO="debian"
ENV GOARCH="amd64"
ENV SERVICE_ADDR="meshery-cilium"
ENV MESHERY_SERVER="http://meshery:9081"
WORKDIR /
COPY templates/ ./templates
COPY --from=build-env /github.com/meshery/meshery-cilium/meshery-cilium .
COPY --from=jsonschema-util /kubeopenapi-jsonschema /root/.meshery/bin/kubeopenapi-jsonschema
ENTRYPOINT ["./meshery-cilium"]
