FROM ubuntu:20.04 as builder

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y build-essential cmake libmysqlclient-dev libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /src
COPY dependencies/ /src/dependencies/
COPY include/ /src/include/
COPY src/ /src/src/
COPY CMakeLists.txt /src/

RUN mkdir build && cd build && cmake .. && make -j

FROM ubuntu:20.04

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y libmysqlclient21 libcurl4 jq && rm -rf /var/lib/apt/lists/*;

WORKDIR /srv
COPY --from=builder /src/bin/osu-performance /srv/osu-performance
COPY ./scripts/docker-entrypoint.sh /srv/docker-entrypoint.sh
RUN chown -R 1000:1000 /srv

USER 1000:1000

ENTRYPOINT [ "/srv/docker-entrypoint.sh" ]
