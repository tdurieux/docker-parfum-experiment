FROM carml/base:amd64-gpu-latest
MAINTAINER Abdul Dakkak <dakkak@illinois.edu>

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
ARG VERSION
ARG ARCH
ARG FRAMEWORK_VERSION
LABEL org.mlmodelscope.go-tensorrt.build-date=$BUILD_DATE \
  org.mlmodelscope.go-tensorrt.name="go-tensorrt bindings for go with cuda support" \
  org.mlmodelscope.go-tensorrt.description="" \
  org.mlmodelscope.go-tensorrt.url="https://www.mlmodelscope.org/" \
  org.mlmodelscope.go-tensorrt.vcs-ref=$VCS_REF \
  org.mlmodelscope.go-tensorrt.vcs-url=$VCS_URL \
  org.mlmodelscope.go-tensorrt.vendor="MLModelScope" \
  org.mlmodelscope.go-tensorrt.arch=$ARCH \
  org.mlmodelscope.go-tensorrt.version=$VERSION \
  org.mlmodelscope.go-tensorrt.framework_version=$FRAMEWORK_VERSION \
  org.mlmodelscope.go-tensorrt.schema-version="1.0"

########## TENSORRT INSTALLATION ###################

RUN cd /tmp/ && wget -q -O tensorrt.deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvinfer-runtime-trt-repo-ubuntu1804-${FRAMEWORK_VERSION}-ga-cuda10.0_1-1_amd64.deb

RUN dpkg -i /tmp/tensorrt.deb && \
  apt-get update && \
  apt-get install -y --no-install-recommends libnvinfer-dev && \
  rm -rf /var/lib/apt/lists/* /tmp/tensorrt.deb

########## GO BINDING INSTALLATION ###################
ENV PKG github.com/rai-project/go-tensorrt
WORKDIR $GOPATH/src/$PKG

RUN git clone --depth=1 --branch=master https://${PKG}.git .

RUN dep ensure -v -no-vendor -update \
    github.com/rai-project/go-tensorrt \
    github.com/rai-project/dlframework && \
    dep ensure -v -vendor-only

RUN go build -a -installsuffix cgo -ldflags "-s -w -X ${PKG}/Version=${VERSION} -X ${PKG}/GitCommit=${VCS_REF} -X ${PKG}/BuildDate=${BUILD_DATE}"&& \
  go install && \
  rm -fr vendor