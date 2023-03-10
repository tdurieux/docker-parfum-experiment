#
# About: Docker container for network measurement.
#
# Build and installed tools:
#
# - Sockperf (https://github.com/mellanox/sockperf): Network benchmarking
# utility over socket API that was designed for testing performance (NETWORK
# and throughput) of high-performance systems.
#
# - Flent (https://flent.org/): Easily run network tests composing multiple
# well-known benchmarking tools into aggregate, repeatable test runs.
#

# ISSUE: Netperf is not in the official repo of Debian:buster
# FROM bitnami/minideb:stretch

FROM ubuntu:18.04

RUN apt-get update --fix-missing \
    && apt-get install --no-install-recommends -y wget ca-certificates iproute2 net-tools telnet tcpdump iputils-ping procps \
        iperf iperf3 \
        flent netperf python3-setuptools \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives && rm -rf /var/lib/apt/lists/*;

ENV NETWORK_MEASUREMENT_SRC /opt/network_measurement
RUN mkdir -p ${NETWORK_MEASUREMENT_SRC}
WORKDIR ${NETWORK_MEASUREMENT_SRC}
# MARK: Compile Sockperf from source code require much resources... Therefore, download deb from this link
RUN wget https://ftp.br.debian.org/debian/pool/main/s/sockperf/sockperf_3.6-2_amd64.deb -O ./sockperf.deb \
    && dpkg -i ./sockperf.deb \
    && rm ./sockperf.deb

CMD ["bash"]
