FROM debian:8

RUN apt-get update && apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;

VOLUME [ "/repo" ]
WORKDIR /repo/bridge

ENTRYPOINT [ "make", "-f", "Makefile.linux" ]