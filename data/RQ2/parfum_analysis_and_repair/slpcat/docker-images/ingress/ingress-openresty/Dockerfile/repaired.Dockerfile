#upstream https://github.com/meyskens/k8s-openresty-ingress
ARG ARCH
# Build go binary
FROM golang AS gobuild

COPY ./ /go/src/github.com/meyskens/k8s-openresty-ingress
WORKDIR /go/src/github.com/meyskens/k8s-openresty-ingress/controller

ARG GOARCH
ARG GOARM

RUN GOARCH=${GOARCH} GOARM=${GOARM} go build ./

# Set up deinitive image
ARG ARCH
FROM maartje/openresty:${ARCH}-1.13.6.1

# Add Dummy cert for dummy conf