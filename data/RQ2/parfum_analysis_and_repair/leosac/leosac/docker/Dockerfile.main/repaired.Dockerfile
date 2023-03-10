FROM debian:bullseye
ARG TARGETPLATFORM

VOLUME /etc/leosac.d

ADD . /tmp/leosac/

RUN apt-get update -qq && apt-get upgrade -qq && apt-get install -y --no-install-recommends -qq \
libboost-regex1.74.0 libboost-serialization1.74.0 libcurl4 libodb-2.4 \
libodb-boost-2.4 libodb-pgsql-2.4 libodb-sqlite-2.4 libscrypt0 libzmq5 && rm -rf /var/lib/apt/lists/*;

RUN dpkg --install /tmp/leosac/${TARGETPLATFORM}/leosac_*.deb

# Container config
CMD [""]
ENTRYPOINT ["leosac", "-k", "/etc/leosac.d/kernel.xml"]
EXPOSE 8888
