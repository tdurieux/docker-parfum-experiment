FROM golang:1.17.9-bullseye as build

COPY . /src/loki
WORKDIR /src/loki
# Backports repo required to get a libsystemd version 246 or newer which is required to handle journal +ZSTD compression
RUN echo "deb http://deb.debian.org/debian bullseye-backports main" >> /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -t bullseye-backports -qy libsystemd-dev && rm -rf /var/lib/apt/lists/*;
RUN make clean && make BUILD_IN_CONTAINER=false promtail

# Promtail requires debian as the base image to support systemd journal reading
FROM debian:bullseye-slim
# tzdata required for the timestamp stage to work
# Backports repo required to get a libsystemd version 246 or newer which is required to handle journal +ZSTD compression
RUN echo "deb http://deb.debian.org/debian bullseye-backports main" >> /etc/apt/sources.list
RUN apt-get update && \
  apt-get install --no-install-recommends -qy \
  tzdata ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -t bullseye-backports -qy libsystemd-dev && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY --from=build /src/loki/clients/cmd/promtail/promtail /usr/bin/promtail
COPY clients/cmd/promtail/promtail-docker-config.yaml /etc/promtail/config.yml
ENTRYPOINT ["/usr/bin/promtail"]
CMD ["-config.file=/etc/promtail/config.yml"]
