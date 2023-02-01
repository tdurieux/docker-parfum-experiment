ARG ALPINE_VERSION="latest"
FROM alpine:${ALPINE_VERSION}
LABEL maintainer="zephinzer <dev-at-joeir-dot-net>" \
      description="CI image for tasks requiring interaction with a k8s installation"
ENV APK_DEPENDENCIES="bash curl git jq vim docker" \
    PATHS_TO_REMOVE="\
      /usr/include/* \
      /usr/share/man/* \
      /var/cache/apk/* \
      ~/.cache/pip/* \
      /var/cache/misc/*"
WORKDIR /
USER root
COPY ./version-info /usr/bin
RUN apk add --update --upgrade --no-cache ${APK_DEPENDENCIES} \
    && curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/bin/kubectl \
    && rm -rf ${PATHS_TO_REMOVE}