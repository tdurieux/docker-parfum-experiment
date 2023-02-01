FROM ubuntu:xenial
ARG  DEPS
ENV  ARGS -V
RUN apt update && apt install --no-install-recommends -y ${DEPS} && rm -rf /var/lib/apt/lists/*;
CMD  mkdir -p /build && cd /build && cmake /src && VERBOSE=1 make -j2 && make test
