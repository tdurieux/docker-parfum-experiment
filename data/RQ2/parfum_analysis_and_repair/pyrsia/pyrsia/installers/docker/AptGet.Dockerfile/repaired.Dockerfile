FROM ubuntu:focal

EXPOSE 7888
EXPOSE 44000

# Send logging to stdout and stderr
ENV RUST_LOG=info

RUN apt-get update; \
    apt-get -y --no-install-recommends install wget gnupg2; rm -rf /var/lib/apt/lists/*; \
    wget -O - https://pyrsia.io/install.sh | sh;

ENTRYPOINT [ "/usr/bin/pyrsia_node", "--host", "0.0.0.0", "-L", "/ip4/0.0.0.0/tcp/44000" ]
