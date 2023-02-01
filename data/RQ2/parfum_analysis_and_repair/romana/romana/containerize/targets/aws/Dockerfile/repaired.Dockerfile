FROM debian:stable-slim
MAINTAINER Caleb Gilmour <cgilmour@romana.io>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y ca-certificates && rm -rf /var/lib/apt/lists/*;
COPY romana_aws /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/romana_aws"]
