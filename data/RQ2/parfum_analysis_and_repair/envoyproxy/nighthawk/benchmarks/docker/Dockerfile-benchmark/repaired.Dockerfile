FROM frolvlad/alpine-python3

RUN apk add --no-cache docker openrc
RUN rc-update add docker boot

ADD benchmarks /usr/local/bin/benchmarks

WORKDIR /usr/local/bin/benchmarks

ENV ENVOY_PATH="envoy" \
    RUNFILES_DIR="/usr/local/bin/benchmarks/benchmarks.runfiles/" \
    ENVOY_IP_TEST_VERSIONS="v4only"

CMD ["./benchmarks", "--help"]