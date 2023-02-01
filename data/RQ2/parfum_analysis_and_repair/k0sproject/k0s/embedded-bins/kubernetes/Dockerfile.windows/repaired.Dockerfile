ARG BUILDIMAGE
FROM $BUILDIMAGE AS build

ARG VERSION
ENV GOPATH=/go
ENV COMMANDS="kubelet kube-proxy"
ENV KUBE_BUILD_PLATFORMS=windows/amd64

RUN apk add --no-cache build-base git go-bindata linux-headers rsync grep coreutils bash

RUN mkdir -p $GOPATH/src/github.com/kubernetes/kubernetes
RUN git -c advice.detachedHead=false clone -b v$VERSION --depth=1 https://github.com/kubernetes/kubernetes.git $GOPATH/src/github.com/kubernetes/kubernetes
WORKDIR /go/src/github.com/kubernetes/kubernetes
RUN \
	set -e; \
	for cmd in $COMMANDS; do \
		make GOFLAGS="-v -tags=providerless" GOLDFLAGS="-extldflags=-static -w -s" WHAT=cmd/$cmd; \
	done

FROM scratch
COPY --from=build \
	/go/src/github.com/kubernetes/kubernetes/_output/local/bin/windows/*/kubelet.exe \
	/go/src/github.com/kubernetes/kubernetes/_output/local/bin/windows/*/kube-proxy.exe \
	/bin/
CMD ["/bin/kubelet.exe"]
