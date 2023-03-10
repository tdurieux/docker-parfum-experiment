FROM alpine:3.12.3
RUN apk upgrade --no-cache && apk add --no-cache musl libstdc++ libuv \
  boost-program_options boost-system boost-date_time boost-filesystem \
  boost-iostreams libnetfilter_conntrack libssl1.1 libcrypto1.1 ca-certificates \
  && update-ca-certificates
COPY bin/opflex_server /usr/local/bin/
COPY bin/gbp_inspect /usr/local/bin/
COPY bin/launch-opflexserver.sh /usr/local/bin/
COPY lib/* /usr/local/lib/
CMD ["/usr/local/bin/launch-opflexserver.sh"]