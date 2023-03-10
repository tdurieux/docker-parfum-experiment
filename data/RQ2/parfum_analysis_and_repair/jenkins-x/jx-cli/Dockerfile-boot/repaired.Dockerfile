FROM alpine:3.12

ARG BUILD_DATE
ARG VERSION
ARG REVISION
ARG TARGETARCH
ARG TARGETOS

LABEL maintainer="jenkins-x"

RUN addgroup -S app \
    && adduser -S -g app app \
    && apk --no-cache add \
    ca-certificates curl git make netcat-openbsd

#WORKDIR /home
#ENV HOME /home

ENV JX_HOME /home/.jx
ENV JX3_HOME /home/.jx

ENV YQ_VERSION "4.6.1"

RUN echo using yq version ${YQ_VERSION} and OS ${TARGETOS} arch ${TARGETARCH} && \
  curl -f -L -s https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_${TARGETOS}_${TARGETARCH} > yq && \
  chmod +x yq && mv yq /usr/bin

RUN echo using jx version ${VERSION} and OS ${TARGETOS} arch ${TARGETARCH} && \
  mkdir -p /home/.jx3 && \
  curl -f -L https://github.com/jenkins-x/jx-cli/releases/download/v${VERSION}/jx-cli-${TARGETOS}-${TARGETARCH}.tar.gz | tar xzv && \
  mv jx /usr/bin

RUN jx upgrade plugins --boot --path /usr/bin

#RUN chown -R app:app /usr/bin/jx /home
#USER app



