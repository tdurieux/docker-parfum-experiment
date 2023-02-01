ARG ALPINE_VERSION="latest"
FROM alpine:${ALPINE_VERSION}
LABEL maintainer="zephinzer <dev-at-joeir-dot-net>" \
      description="Image used for running general tasks in the CI pipeline"
ENV APK_DEPENDENCIES="bash curl jq vim git openssh gnupg lighttpd vsftpd lftp" \
    CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium \
    PATHS_TO_REMOVE="\
      /usr/include/* \
      /usr/share/man/* \
      /var/cache/apk/* \
      ~/.cache/pip/* \
      /var/cache/misc/*"
USER root
WORKDIR /app
COPY ./version-info /usr/bin/
RUN apk add --update --upgrade --no-cache ${APK_DEPENDENCIES} \
  && chmod +x /usr/bin/version-info \
  && rm -rf ${PATHS_TO_REMOVE} \
  && addgroup -g 1000 app \
  && adduser -u 1000 app -h /app -G app -D \
  && chown app:app /app \
  && echo 'alias md5="md5sum"' > ~/.profile \
  && echo 'alias ll="ls -alg"' >> ~/.profile \
  && echo 'export PS1="\D{%Y%m%d%H%M%S}|\h \w $ "' >> ~/.profile \
  && echo 'source ~/.profile' > ~/.bashrc