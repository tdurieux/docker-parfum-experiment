FROM debian:latest
LABEL Description="Image for building gnuK"

RUN apt update -y && apt install --no-install-recommends -y make gcc-arm-none-eabi && apt clean && rm -rf /var/lib/apt/lists/*;

# takes 100 MB of space more
RUN apt install --no-install-recommends -y git && apt clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /gnuk/

CMD ["/bin/sh", "-c", "cd /gnuk/src && ./configure $GNUK_CONFIG && cd /gnuk/regnual && make clean && make && cd /gnuk/src && make clean && ./configure $GNUK_CONFIG && make && mkdir -p /gnuk/release/`git describe --long`/ && cp /gnuk/src/build/gnuk.* /gnuk/regnual/regnual.bin /gnuk/release/`git describe --long`/ -v && git describe --long >/gnuk/release/.last && cd /gnuk/release && rm last-build && ln -sf `git describe --long` last-build" ]
