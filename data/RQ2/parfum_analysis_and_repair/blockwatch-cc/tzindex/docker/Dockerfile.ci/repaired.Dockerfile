# syntax=docker/dockerfile:experimental
# build stage
FROM          golang:alpine AS tzindex-builder
ARG           REPO=blockwatch.cc/tzindex
ARG           BUILD_TARGET=tzindex
ARG           BUILD_VERSION=dev
ARG           BUILD_COMMIT=none
LABEL         autodelete="true"
ADD           . /go/src/${BUILD_TARGET}
WORKDIR       /go/src/${BUILD_TARGET}
ENV           GOPATH=/go
RUN           apk --no-cache add git binutils
RUN           git checkout ${BUILD_TAG}
RUN           go install -v -ldflags "-X main.version=${BUILD_VERSION} -X main.commit=${BUILD_COMMIT}" ./cmd/...
RUN           go install github.com/echa/gttp

# final stage