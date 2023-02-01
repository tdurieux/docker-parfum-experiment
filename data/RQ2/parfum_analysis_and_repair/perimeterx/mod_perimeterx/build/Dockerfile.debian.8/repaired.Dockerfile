FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && \
    apt install --no-install-recommends -y apache2 apache2-dev libjansson-dev libcurl4-openssl-dev devscripts libtool libssl-dev && rm -rf /var/lib/apt/lists/*;
COPY scripts/build_deb.sh /build_deb.sh

CMD /build_deb.sh
