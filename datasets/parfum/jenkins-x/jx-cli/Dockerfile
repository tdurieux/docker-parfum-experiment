FROM gcr.io/jenkinsxio/jx-cli-base-image:0.0.46

ARG VERSION
ARG TARGETARCH
ARG TARGETOS

ENV HOME /home
ENV JX3_HOME /home/.jx3

RUN echo using jx version ${VERSION} and OS ${TARGETOS} arch ${TARGETARCH} && \
  mkdir -p /home/.jx3 && \
  curl -L https://github.com/jenkins-x/jx-cli/releases/download/v${VERSION}/jx-cli-${TARGETOS}-${TARGETARCH}.tar.gz | tar xzv && \
  mv jx /usr/bin

RUN jx upgrade plugins --mandatory
