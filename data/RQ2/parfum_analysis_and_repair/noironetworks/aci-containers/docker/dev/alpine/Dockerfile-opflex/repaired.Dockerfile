FROM alpine:3.12.3
RUN apk upgrade --no-cache && apk add --no-cache musl libstdc++ libuv \
  boost-program_options boost-system boost-date_time boost-filesystem \
  boost-iostreams libnetfilter_conntrack libssl1.1 libcrypto1.1 ca-certificates \
  && update-ca-certificates
COPY bin/* /usr/local/bin/
COPY lib/* /usr/local/lib/
ENV SSL_MODE="encrypted"
ENV REBOOT_WITH_OVS="true"
CMD ["/usr/local/bin/launch-opflexagent.sh"]