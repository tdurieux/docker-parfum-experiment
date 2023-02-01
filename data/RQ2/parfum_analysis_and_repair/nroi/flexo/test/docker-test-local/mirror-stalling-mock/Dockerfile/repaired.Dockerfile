FROM debian:buster-slim

EXPOSE 80

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install --no-install-recommends -y netcat-openbsd && rm -rf /var/lib/apt/lists/*;

COPY stalling_server /usr/local/bin/stalling_server

ENTRYPOINT /usr/local/bin/stalling_server
