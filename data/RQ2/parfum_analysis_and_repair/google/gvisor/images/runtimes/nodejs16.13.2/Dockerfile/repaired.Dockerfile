FROM ubuntu:bionic
RUN apt-get update && apt-get install --no-install-recommends -y \
  curl \
  dumb-init \
  g++ \
  make \
  python \
  python3.8 && rm -rf /var/lib/apt/lists/*;

WORKDIR /root
ARG VERSION=v16.13.2
RUN curl -f -o node-${VERSION}.tar.gz https://nodejs.org/dist/${VERSION}/node-${VERSION}.tar.gz
RUN tar -zxf node-${VERSION}.tar.gz && rm node-${VERSION}.tar.gz

WORKDIR /root/node-${VERSION}
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make test-build

# Including dumb-init emulates the Linux "init" process, preventing the failure
# of tests involving worker processes.
ENTRYPOINT ["/usr/bin/dumb-init"]
