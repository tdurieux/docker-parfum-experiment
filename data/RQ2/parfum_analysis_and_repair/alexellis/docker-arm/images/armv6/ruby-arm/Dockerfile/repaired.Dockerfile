FROM resin/rpi-raspbian
USER root

RUN apt-get update && \
    apt-get -qy --no-install-recommends install ca-certificates ruby && rm -rf /var/lib/apt/lists/*;

CMD ["irb"]
