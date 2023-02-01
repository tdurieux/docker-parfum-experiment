FROM resin/rpi-raspbian

RUN apt-get -qy update && \
    apt-get -qy --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;

CMD ["curl"]
