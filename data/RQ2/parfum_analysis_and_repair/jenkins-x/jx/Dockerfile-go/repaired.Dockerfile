FROM golang:1.17.9

ARG VERSION
ARG TARGETARCH
ARG TARGETOS

#ENV HOME /home
ENV JX3_HOME /home/.jx3

RUN echo using jx version ${VERSION} and OS ${TARGETOS} arch ${TARGETARCH} && \
  mkdir -p /home/.jx3 && \
  curl -f -L https://github.com/jenkins-x/jx/releases/download/v${VERSION}/jx-${TARGETOS}-${TARGETARCH}.tar.gz | tar xzv && \
  mv jx /usr/bin

RUN jx upgrade plugins --mandatory
