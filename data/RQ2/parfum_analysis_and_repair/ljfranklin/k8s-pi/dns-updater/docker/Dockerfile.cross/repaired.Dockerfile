FROM __BASEIMAGE_ARCH__/alpine:3.7

__CROSS_COPY qemu-__QEMU_ARCH__-static /usr/bin/

RUN apk update && \
  apk --no-cache add \
    ca-certificates curl make bash \
    perl \
    perl-digest-sha1 \
    perl-io-socket-ssl \
    perl-json

RUN curl -f -L https://cpanmin.us | perl - App::cpanminus --no-wget && \
    cpanm --no-wget Data::Validate::IP JSON::Any && \
    rm -rf /config/.cpanm /root/.cpanm

RUN curl -f -s -o /usr/local/bin/ddclient \
  https://raw.githubusercontent.com/ddclient/ddclient/v3.9.0/ddclient && \
  chmod +x /usr/local/bin/ddclient

RUN mkdir -p /var/cache/ddclient/
