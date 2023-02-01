FROM golang:1.17.11 as builder

ENV ARCH=amd64
ENV OS=linux

WORKDIR /go/src/github.com/alibaba/hybridnet

COPY go.mod ./go.mod
COPY go.sum ./go.sum
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
RUN go mod download

COPY . /go/src/github.com/alibaba/hybridnet

RUN export GOCACHE=/tmp && \
    export GO111MODULE=on && \
    export GOARCH=${ARCH} && \
    export CGO_ENABLED=0 && \
    export GOOS=${OS} && \
    export COMMIT_ID=`git rev-parse --short HEAD 2>/dev/null` && \
    go build -o dist/images/hybridnet -ldflags "-w -s" -v ./cmd/cni && \
    go build -ldflags "-w -s -X \"main.gitCommit=`echo $COMMIT_ID`\" " -o dist/images/hybridnet-daemon -v ./cmd/daemon && \
    go build -ldflags "-X \"main.gitCommit=`echo $COMMIT_ID`\" " -o dist/images/hybridnet-manager -v ./cmd/manager && \
    go build -ldflags "-X \"main.gitCommit=`echo $COMMIT_ID`\" " -o dist/images/hybridnet-webhook -v ./cmd/webhook && \
    echo $COMMIT_ID > ./COMMIT_ID

RUN cd /go/src/github.com/alibaba/hybridnet/dist/secrets && \
    sh generate-tls-certificates.sh

FROM calico/go-build:v0.57 as felix-builder
ARG GOPROXY
ENV GOPROXY $GOPROXY
ENV GIT_BRANCH=v3.20.2
ENV GIT_COMMIT=ab06c3940caa8ac201f85c1313b2d72d724409d2

ENV ARCH=amd64
ENV OS=linux

RUN mkdir -p /go/src/github.com/projectcalico/ && cd /go/src/github.com/projectcalico/ && \
    git clone -b ${GIT_BRANCH} --depth 1 https://github.com/projectcalico/felix.git && \
    cd felix && [ "`git rev-parse HEAD`" = "${GIT_COMMIT}" ]
COPY policy/felix /hybridnet_patch
RUN cd /go/src/github.com/projectcalico/felix && git apply /hybridnet_patch/*.patch
RUN cd /go/src/github.com/projectcalico/felix && \
    export GOCACHE=/tmp && \
    export GO111MODULE=on && \
    export GOARCH=${ARCH} && \
    export CGO_ENABLED=0 && \
    export GOOS=${OS} && \
    go build -v -o bin/calico-felix -v -ldflags \
    "-X github.com/projectcalico/felix/buildinfo.GitVersion=${GIT_BRANCH} \
    -X github.com/projectcalico/felix/buildinfo.BuildDate=$(date -u +'%FT%T%z') \
    -X github.com/projectcalico/felix/buildinfo.GitRevision=${GIT_COMMIT} \
    -B 0x${GIT_COMMIT}" "github.com/projectcalico/felix/cmd/calico-felix" && \
    chmod +x /go/src/github.com/projectcalico/felix/bin/calico-felix

FROM alpine:3.14

# replace apk source url
RUN sed -i s@/dl-cdn.alpinelinux.org/@/mirrors.aliyun.com/@g /etc/apk/repositories && \
	chmod +x /bin/*

RUN apk update

RUN apk add --no-cache --allow-untrusted \
    bash \
	iptables \
	ip6tables \
	iproute2 \
	ipset \
	conntrack-tools \
	curl \
	perl \
	tar

ENV CNI_VERSION=v0.9.1
RUN mkdir -p cni-plugins/ && \
    curl -f -SL https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-amd64-${CNI_VERSION}.tgz \
    | tar -xz -C cni-plugins/

RUN mkdir -p gobgp/ && \
    curl -f -SL https://github.com/osrg/gobgp/releases/download/v3.0.0-rc4/gobgp_3.0.0-rc4_linux_amd64.tar.gz \
    | tar -xz -C gobgp/ && \
    cp gobgp/gobgp /usr/bin/ && \
    rm -rf gobgp/

COPY dist/images/start-daemon.sh /hybridnet/start-daemon.sh
COPY dist/images/install-cni.sh /hybridnet/install-cni.sh
COPY dist/images/00-hybridnet.conflist /hybridnet/00-hybridnet.conflist

COPY dist/images/iptables-wrapper-installer.sh /
RUN /iptables-wrapper-installer.sh --no-sanity-check

COPY --from=builder /go/src/github.com/alibaba/hybridnet/dist/images/hybridnet /hybridnet/hybridnet
COPY --from=builder /go/src/github.com/alibaba/hybridnet/dist/images/hybridnet-daemon /hybridnet/hybridnet-daemon
COPY --from=builder /go/src/github.com/alibaba/hybridnet/dist/images/hybridnet-manager /hybridnet/hybridnet-manager
COPY --from=builder /go/src/github.com/alibaba/hybridnet/dist/images/hybridnet-webhook /hybridnet/hybridnet-webhook
COPY --from=builder /go/src/github.com/alibaba/hybridnet/COMMIT_ID /hybridnet/COMMIT_ID

COPY --from=felix-builder /go/src/github.com/projectcalico/felix/bin/calico-felix /hybridnet/calico-felix
COPY policy/policyinit.sh /hybridnet/

RUN mkdir -p /tmp/k8s-webhook-server/serving-certs

COPY --from=builder /go/src/github.com/alibaba/hybridnet/dist/secrets/tls.crt /tmp/k8s-webhook-server/serving-certs/tls.crt
COPY --from=builder /go/src/github.com/alibaba/hybridnet/dist/secrets/tls.key /tmp/k8s-webhook-server/serving-certs/tls.key
