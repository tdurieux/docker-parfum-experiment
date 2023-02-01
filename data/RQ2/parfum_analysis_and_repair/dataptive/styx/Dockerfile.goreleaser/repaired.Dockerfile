FROM alpine:latest

WORKDIR /

COPY styx-server /usr/local/bin/
COPY styx /usr/local/bin/
COPY config.toml /etc/styx/

RUN mkdir data

ENTRYPOINT ["styx-server", "--config", "/etc/styx/config.toml", "--log-level", "INFO"]

EXPOSE 7123