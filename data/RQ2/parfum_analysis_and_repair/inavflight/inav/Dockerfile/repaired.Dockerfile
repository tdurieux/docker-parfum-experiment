FROM ubuntu:focal

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y git cmake make ruby gcc && rm -rf /var/lib/apt/lists/*;

RUN useradd inav

USER inav

VOLUME /src

WORKDIR /src/build
ENTRYPOINT ["/src/cmake/docker.sh"]
