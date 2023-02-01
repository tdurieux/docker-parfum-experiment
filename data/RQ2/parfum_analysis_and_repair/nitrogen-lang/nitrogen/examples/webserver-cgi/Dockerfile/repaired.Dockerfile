FROM ubuntu:16.04

RUN apt update && apt install -y --no-install-recommends fcgiwrap && rm -rf /var/cache/apk/* && rm -rf /var/lib/apt/lists/*;

STOPSIGNAL SIGTERM
ENTRYPOINT [ "fcgiwrap", "-s", "tcp:0.0.0.0:9000", "-f" ]
