FROM debian:10.10-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    groupadd -r aurora --gid 999; \
    useradd -r -g aurora --uid 999 --no-log-init -m aurora;

# make sure mounted volumes have correct permissions
RUN mkdir -p /home/aurora/.aurora && chown 999:999 /home/aurora/.aurora

COPY aurora /usr/local/bin/aurora

EXPOSE 1633 1634 1635
USER aurora
WORKDIR /home/aurora
VOLUME /home/aurora/.aurora

ENTRYPOINT ["aurora"]