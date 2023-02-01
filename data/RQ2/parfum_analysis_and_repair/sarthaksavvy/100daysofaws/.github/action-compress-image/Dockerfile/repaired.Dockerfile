FROM ubuntu:latest

RUN apt update; \
    apt install --no-install-recommends wget -y; rm -rf /var/lib/apt/lists/*; \
    apt install --no-install-recommends imagemagick -y;

COPY entrypoint.sh /usr/local/bin/entrypoint

RUN chmod +x /usr/local/bin/entrypoint

ENTRYPOINT ["/usr/local/bin/entrypoint"]