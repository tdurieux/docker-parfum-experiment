FROM debian:stable-slim
MAINTAINER Caleb Gilmour <cgilmour@romana.io>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y bird iproute2 && rm -rf /var/lib/apt/lists/*;
COPY run-bird /usr/local/bin

ENTRYPOINT ["/usr/local/bin/run-bird"]
