FROM debian:jessie
MAINTAINER Jessica Frazelle <jess@docker.com>

RUN apt-get update && apt-get install -y \
    icedove \
    --no-install-recommends

ENTRYPOINT [ "icedove" ]
