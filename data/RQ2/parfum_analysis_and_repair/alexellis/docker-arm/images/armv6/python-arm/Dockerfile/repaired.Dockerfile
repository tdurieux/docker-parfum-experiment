FROM resin/rpi-raspbian
USER root

RUN apt-get update && \
    apt-get -qy --no-install-recommends install ca-certificates python python-pip && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get -qy clean all
CMD ["python"]
