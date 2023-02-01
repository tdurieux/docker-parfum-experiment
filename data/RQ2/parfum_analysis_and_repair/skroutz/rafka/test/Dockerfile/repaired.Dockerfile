# DIST and RDKAFKA_VERSION are required build arguments.
ARG DIST
FROM debian:${DIST}

ARG RDKAFKA_VERSION

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    procps \
    curl gnupg \
    build-essential && rm -rf /var/lib/apt/lists/*;

ADD skroutz-stable.list /etc/apt/sources.list.d/
ADD skroutz-pu.list /etc/apt/sources.list.d/
RUN curl -f -sSL https://debian.skroutz.gr/skroutz.asc | apt-key add -

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      golang \
      go-dep \
      git \
      ruby-full \
      bundler \
      confluent-kafka-2.11 \
      default-jre && rm -rf /var/lib/apt/lists/*;

# build librdkafka
RUN git clone git://github.com/edenhill/librdkafka /tmp/librdkafka
WORKDIR /tmp/librdkafka
RUN git checkout ${RDKAFKA_VERSION} && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --libdir=/usr/lib/$(dpkg-architecture -q DEB_HOST_GNU_TYPE) && make && make install

ENV GOPATH /root/go
ENV RAFKA rafka:6380
VOLUME $GOPATH/src/github.com/skroutz/rafka
WORKDIR $GOPATH/src/github.com/skroutz/rafka

EXPOSE 6380

CMD ["make", "run-rafka-local"]
