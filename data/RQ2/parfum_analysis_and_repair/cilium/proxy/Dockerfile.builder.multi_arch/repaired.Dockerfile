#
# Builder dependencies. This takes a long time to build from scratch!
# Also note that if build fails due to C++ internal error or similar,
# it is possible that the image build needs more RAM than available by
# default on non-Linux docker installs.
#
# Using cilium-builder as the base to ensure libc etc. are in sync.
#
# The base image here should be multi-arched beforehand when used for non-amd64
# platforms, e.g, arm64 platform.
#
FROM quay.io/cilium/cilium-builder:2020-05-05 as builder

LABEL maintainer="maintainer@cilium.io"

ARG ARCH=amd64

WORKDIR /go/src/github.com/cilium/cilium/envoy
COPY . ./

#
# Additional Envoy Build dependencies
#
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y --no-install-recommends \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		automake \
		cmake \
		g++ \
		git \
		libtool \
		make \
		ninja-build \
		python3 \
		python \
		wget \
		zip \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#
# Install Bazel
#
RUN export BAZEL_VERSION=`cat .bazelversion` \
        && if [ "$ARCH" = "amd64" ] ;then \
	     curl -sfL https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh -o bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh \
	     && chmod +x bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh \
	     && ./bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh \
	     && mv /usr/local/bin/bazel /usr/bin \
	     && rm bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh ; \
           elif [ "$ARCH" = "arm64" ] ; then \
             apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y curl unzip zip build-essential openjdk-11-jdk && \
             echo "deb https://download.opensuse.org/repositories/home:/mrostecki:/bazel/xUbuntu_20.04/ /" > /etc/apt/sources.list.d/bazel.list && \
             curl -f -L https://download.opensuse.org/repositories/home:/mrostecki:/bazel/xUbuntu_20.04/Release.key | apt-key add - && \
             apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y bazel; rm -rf /var/lib/apt/lists/*; \
           fi


#
# Build and keep the cache
#
RUN make BAZEL_BUILD_OPTS=--jobs=5 PKG_BUILD=1 ./bazel-bin/cilium-envoy && rm ./bazel-bin/cilium-envoy

#
# Absolutely nothing after making envoy deps!
#
