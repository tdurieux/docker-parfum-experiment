FROM magneticio/vamp:VAMP_VERSION

ADD vamp.sh /usr/local/vamp/vamp

RUN set -ex && \
    apk --update --no-cache add curl && \
    rm /var/cache/apk/* && \
    chmod +x /usr/local/vamp/vamp
