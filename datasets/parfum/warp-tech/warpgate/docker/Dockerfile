FROM rust:bullseye AS build

ENV DEBIAN_FRONTEND noninteractive

RUN curl -fsSL https://deb.nodesource.com/setup_17.x | bash - \
    && apt-get update \
    && apt-get install -y nodejs openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g yarn \
    && cargo install just

COPY . /opt/warpgate

RUN cd /opt/warpgate \
    && just yarn \
    && just openapi \
    && just yarn build \
    && cargo build --release

FROM debian:bullseye
LABEL maintainer=heywoodlh

COPY --from=build /opt/warpgate/target/release/warpgate /usr/local/bin/warpgate

VOLUME /data

ENV DOCKER 1

ENTRYPOINT ["warpgate", "--config", "/data/warpgate.yaml"]
CMD ["run"]
