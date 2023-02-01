FROM ghcr.io/interline-io/valhalla-docker/valhalla:v3.1.4

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install libboost-program-options1.65.1 && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir /build/valhalla_tiles && \
  chmod og+w -R /build/valhalla_tiles && \
  valhalla_build_config \
  --mjolnir-tile-dir /build/valhalla_tiles \
  --mjolnir-tile-extract /build/valhalla_tiles.tar \
  --mjolnir-timezone /build/valhalla_tiles/timezones.sqlite \
  --mjolnir-admin /build/valhalla_tiles/admins.sqlite \
  > /build/valhalla.json

COPY valhalla_convert.sh /
ENTRYPOINT ["/valhalla_convert.sh"]
CMD []
