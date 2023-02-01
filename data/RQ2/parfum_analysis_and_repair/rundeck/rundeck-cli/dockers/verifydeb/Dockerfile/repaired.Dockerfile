FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get -y --no-install-recommends install dpkg-sig && rm -rf /var/lib/apt/lists/*;



VOLUME /data

WORKDIR /data
COPY script.sh /data/script.sh

CMD ./script.sh /build
