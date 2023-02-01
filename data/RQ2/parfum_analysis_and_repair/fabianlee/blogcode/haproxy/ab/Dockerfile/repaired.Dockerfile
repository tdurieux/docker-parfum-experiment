FROM alpine:latest

RUN apk update && \
 apk add --no-cache wget && \
 mkdir /usr/src && rm -rf /usr/src
WORKDIR /usr/src

RUN wget https://archive.apache.org/dist/httpd/httpd-2.4.37.tar.gz && \
 tar xvfz httpd-*.tar.gz && rm httpd-*.tar.gz
WORKDIR /usr/src/httpd-2.4.37

RUN cp support/ab.c support/ab.c.old &&\
 wget https://raw.githubusercontent.com/fabianlee/blogcode/master/haproxy/ab.c -O support/ab.c && \
 apk add --no-cache build-base apr-dev apr apr-util apr-util-dev pcre pcre-dev && \
 ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
 make && \
 cp support/ab /usr/sbin/ab

ENTRYPOINT ["/usr/sbin/ab"]
