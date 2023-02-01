FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y coturn && rm -rf /var/lib/apt/lists/*;

USER turnserver

ENTRYPOINT ["/usr/bin/turnserver"]