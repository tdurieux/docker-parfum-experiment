FROM debian:latest
LABEL Description="Image for building gnuK"

RUN apt update -y && apt install --no-install-recommends -y make gcc-arm-none-eabi && apt clean && rm -rf /var/lib/apt/lists/*;

CMD ["/bin/sh", "-c", "cd /gnuk/src && make clean && ./configure $GNUK_CONFIG && make"]
