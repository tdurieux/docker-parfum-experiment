FROM alpine:3.8 as go_builder
RUN \
  apk add --no-cache --virtual .build-deps bash gcc musl-dev openssl go; \
  wget -O go.src.tar.gz https://dl.google.com/go/go1.13.3.src.tar.gz; \
  tar -C /usr/local -xzf go.src.tar.gz; rm go.src.tar.gz \
  cd /usr/local/go/src/ && ./make.bash; \
  apk del .build-deps

FROM centos:centos7

COPY --from=go_builder /usr/local/go /usr/local
RUN yum install -y make rpm-build git && rm -rf /var/cache/yum
RUN mkdir -p /rpmbuild/{SOURCES,SPECS,BUILD,RPMS,SRPMS}
RUN echo "%_topdir /rpmbuild" > ~/.rpmmacros

CMD ["/bin/sh"]