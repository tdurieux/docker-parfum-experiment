FROM ubuntu:16.04
MAINTAINER Casey Davenport <casey@tigera.io>

RUN apt-get update && apt-get install --no-install-recommends -y iptables && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/bin/sh"]
