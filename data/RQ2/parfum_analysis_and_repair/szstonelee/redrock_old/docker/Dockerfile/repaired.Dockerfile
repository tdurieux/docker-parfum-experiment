FROM ubuntu:18.04 AS build

WORKDIR /redrock

RUN apt-get update && apt-get -y --no-install-recommends install \
            make \
            cmake \
            gcc \
            g++ \
            autoconf \
            git; rm -rf /var/lib/apt/lists/*; \
    git clone https://github.com/szstonelee/redrock redrock; \
    cd redrock; \
    git submodule init; \
    git submodule update; \
    cd src; \
    make

FROM ubuntu:18.04

VOLUME /redrock/rockdbdir

WORKDIR /redrock

COPY --from=build /redrock/redrock/src/redis-server /redrock
COPY start_redrock.sh /redrock
RUN chmod +x /redrock/start_redrock.sh

EXPOSE 6379

CMD ["/redrock/start_redrock.sh"]
