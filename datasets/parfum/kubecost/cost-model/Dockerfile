FROM golang:latest as build-env

RUN mkdir /app
WORKDIR /app
COPY go.mod .
COPY go.sum .

# This ensures that CGO is disabled for go test running AND for the build
# step. This prevents a build failure when building an ARM64 image with
# docker buildx. I believe this is because the ARM64 version of the
# golang:latest image does not contain GCC, while the AMD64 version does.
ARG CGO_ENABLED=0

ARG version=dev
ARG	commit=HEAD

# Get dependencies - will also be cached if we won't change mod/sum
RUN go mod download
# COPY the source code as the last step
COPY . .
# Build the binary
RUN set -e ;\
    go test ./test/*.go;\
    go test ./pkg/*;\
    cd cmd/costmodel;\
    GOOS=linux \
    go build -a -installsuffix cgo \
    -ldflags \
    "-X github.com/kubecost/opencost/pkg/version.Version=${version} \
     -X github.com/kubecost/opencost/pkg/version.GitCommit=${commit}" \
    -o /go/bin/app

FROM alpine:latest
RUN apk add --update --no-cache ca-certificates
COPY --from=build-env /go/bin/app /go/bin/app
ADD ./configs/default.json /models/default.json
ADD ./configs/azure.json /models/azure.json
ADD ./configs/aws.json /models/aws.json
ADD ./configs/gcp.json /models/gcp.json
USER 1001
ENTRYPOINT ["/go/bin/app"]
