ARG NODE_MAJOR_VERSION="9"
FROM node:${NODE_MAJOR_VERSION}-alpine
LABEL maintainer="zephinzer <dev-at-joeir-dot-net>" \
      description="Node ${NODE_MAJOR_VERSION}.* container for use in CI pipelines"
ENV APK_DEPENDENCIES="bash curl git jq vim make g++" \
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
    && chmod +x /usr/bin/version-info \
    && rm -rf ${PATHS_TO_REMOVE}