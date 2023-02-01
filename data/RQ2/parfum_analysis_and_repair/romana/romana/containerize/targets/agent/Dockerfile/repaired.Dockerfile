FROM debian:stable-slim
MAINTAINER Caleb Gilmour <cgilmour@romana.io>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y iptables iproute2 jq curl ipset && rm -rf /var/lib/apt/lists/*;
COPY kubectl etcdctl /usr/local/bin/
RUN mkdir -p /var/lib/romana/cni-installation /var/lib/romana/templates
COPY romana_cni 10-romana.conf /var/lib/romana/cni-installation/
RUN mkdir -p /var/lib/rlog/
COPY romana-rlog.conf /var/lib/rlog/
COPY dot-romana.template /var/lib/romana/templates/
COPY romana /usr/local/bin/
COPY romana_agent /usr/local/bin/
COPY run-romana-agent /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/run-romana-agent"]
