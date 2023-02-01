FROM alpine:3.14
ARG test
RUN apk update
RUN apk add --no-cache build-base linux-headers git bash libunwind-dev
RUN mkdir -p /usr/src && rm -rf /usr/src
RUN git clone https://github.com/namhyung/uftrace /usr/src/uftrace
RUN if [ "${test}" == "yes" ] ; then \
        cd /usr/src/uftrace && ./misc/install-deps.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make unittest; \
    else \
        cd /usr/src/uftrace && ./misc/install-deps.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install; \
    fi
