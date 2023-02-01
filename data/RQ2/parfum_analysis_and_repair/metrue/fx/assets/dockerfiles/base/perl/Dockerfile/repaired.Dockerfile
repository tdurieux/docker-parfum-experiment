FROM alpine:3.4
MAINTAINER Mojolicious

ADD . .
COPY cpanfile /
ENV EV_EXTRA_DEFS -DEV_NO_ATFORK

RUN apk update && \
  apk add --no-cache perl perl-io-socket-ssl perl-dbd-pg perl-dev g++ make wget curl && \
  curl -f -L https://cpanmin.us | perl - App::cpanminus && cpanm --installdeps . -M https://cpan.metacpan.org
