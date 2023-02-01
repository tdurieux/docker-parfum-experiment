# https://github.com/yeasy/docker-hyperledger-fabric-base
#
# Dockerfile for Hyperledger fabric base image.
# If you only need quickly deploy a fabric network, please see
# * yeasy/hyperledger-fabric-peer
# * yeasy/hyperledger-fabric-orderer
# * yeasy/hyperledger-fabric-ca
# Workdir is set to $GOPATH/src/github.com/hyperledger/fabric
# Data is stored under /var/hyperledger/db and /var/hyperledger/production

FROM golang:1.12
LABEL maintainer "Baohua Yang <yangbaohua@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

# Only useful for this Dockerfile
ENV FABRIC_ROOT=$GOPATH/src/github.com/hyperledger/fabric
ENV CHAINTOOL_RELEASE=1.1.2

# Architecture of the node
ENV ARCH=amd64
# version for the base images (baseos, baseimage, ccenv, etc.), used in core.yaml as BaseVersion
ENV BASEIMAGE_RELEASE=0.4.15
# BASE_VERSION is used in metadata.Version as major version
ENV BASE_VERSION=2.0.0
# PROJECT_VERSION is required in core.yaml for fabric-baseos and fabric-ccenv
ENV PROJECT_VERSION=2.0.0
# generic golang cc builder environment (core.yaml): builder: $(DOCKER_NS)/fabric-ccenv:$(ARCH)-$(PROJECT_VERSION)
ENV DOCKER_NS=hyperledger
# for golang or car's baseos for cc runtime: $(BASE_DOCKER_NS)/fabric-baseos:$(ARCH)-$(BASEIMAGE_RELEASE)
ENV BASE_DOCKER_NS=hyperledger
ENV LD_FLAGS="-X github.com/hyperledger/fabric/common/metadata.Version=${BASE_VERSION} \
             -X github.com/hyperledger/fabric/common/metadata.BaseVersion=${BASEIMAGE_RELEASE} \
             -X github.com/hyperledger/fabric/common/metadata.BaseDockerLabel=org.hyperledger.fabric \
             -X github.com/hyperledger/fabric/common/metadata.DockerNamespace=hyperledger \
             -X github.com/hyperledger/fabric/common/metadata.BaseDockerNamespace=hyperledger"

#-X github.com/hyperledger/fabric/common/metadata.Experimental=true \
#-linkmode external -extldflags '-static -lpthread'"

# Peer config path
ENV FABRIC_CFG_PATH=/etc/hyperledger/fabric
RUN mkdir -p /var/hyperledger/db \
        /var/hyperledger/production \
        $GOPATH/src/github.com/hyperledger \
        $FABRIC_CFG_PATH \
        /chaincode/input \
        /chaincode/output

# Install development dependencies
RUN apt-get update \
    && apt-get install -y apt-utils python-dev \
    && apt-get install -y libsnappy-dev zlib1g-dev libbz2-dev libyaml-dev libltdl-dev libtool \
    && apt-get install -y python-pip \
    && apt-get install -y tree jq unzip\
    && rm -rf /var/cache/apt

# install chaintool
#RUN curl -L https://github.com/hyperledger/fabric-chaintool/releases/download/v0.10.3/chaintool > /usr/local/bin/chaintool \
RUN curl -fL https://nexus.hyperledger.org/content/repositories/releases/org/hyperledger/fabric/hyperledger-fabric/chaintool-${CHAINTOOL_RELEASE}/hyperledger-fabric-chaintool-${CHAINTOOL_RELEASE}.jar > /usr/local/bin/chaintool \
    && chmod a+x /usr/local/bin/chaintool

# install gotools
RUN go get github.com/golang/protobuf/protoc-gen-go \
    && go get github.com/maxbrunsfeld/counterfeiter \
    && go get github.com/axw/gocov/... \
    && go get github.com/AlekSi/gocov-xml \
    && go get golang.org/x/tools/cmd/goimports \
    && go get golang.org/x/lint/golint \
    && go get github.com/estesp/manifest-tool \
    && go get github.com/client9/misspell/cmd/misspell \
    && go get github.com/estesp/manifest-tool \
    && go get github.com/onsi/ginkgo/ginkgo

# Clone the Hyperledger Fabric code and cp sample config files
RUN cd $GOPATH/src/github.com/hyperledger \
    && git clone --single-branch -b master --depth 1 http://gerrit.hyperledger.org/r/fabric \
    && echo "*                hard    nofile          10000" >> /etc/security/limits.conf \
    && echo "*                soft    nofile          10000" >> /etc/security/limits.conf \
    && cp -r $FABRIC_ROOT/sampleconfig/* $FABRIC_CFG_PATH/

# install configtxgen, cryptogen, configtxlator, discover, token and idemixgen
RUN cd $FABRIC_ROOT/ \
    && CGO_CFLAGS=" " go install -tags "" github.com/hyperledger/fabric/cmd/configtxgen \
    && CGO_CFLAGS=" " go install -tags "" github.com/hyperledger/fabric/cmd/cryptogen \
    && CGO_CFLAGS=" " go install -tags "" github.com/hyperledger/fabric/cmd/configtxlator \
    && CGO_CFLAGS=" " go install -tags "" -ldflags "-X github.com/hyperledger/fabric/cmd/discover/metadata.Version=2.0.0" github.com/hyperledger/fabric/cmd/discover \
    && CGO_CFLAGS=" " go install -tags "" -ldflags "-X github.com/hyperledger/fabric/cmd/token/metadata.Version=2.0.0" github.com/hyperledger/fabric/cmd/token \
    && CGO_CFLAGS=" " go install -tags "" github.com/hyperledger/fabric/common/tools/idemixgen

# The data and config dir, can map external one with -v
VOLUME /var/hyperledger
#VOLUME /etc/hyperledger/fabric

# temporarily fix the `go list` complain problem, which is required in chaincode packaging, see core/chaincode/platforms/golang/platform.go#GetDepoymentPayload
ENV GOROOT=/usr/local/go

WORKDIR $FABRIC_ROOT

# This is only a workaround for current hard-coded problem when using as fabric-baseimage.
RUN ln -s $GOPATH /opt/gopath
LABEL org.hyperledger.fabric.version=${PROJECT_VERSION} \
      org.hyperledger.fabric.base.version=${BASEIMAGE_RELEASE}
