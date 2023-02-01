FROM debian:stable

RUN apt-get update && apt-get install -y --no-install-recommends \
      make \
      libxml-treebuilder-perl \
      libyaml-libyaml-perl \
      libyaml-perl \
      libjson-xs-perl \
      jq \
      less \
      curl \
      ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL https://github.com/StackExchange/dnscontrol/releases/download/v3.13.0/dnscontrol_3.13.0_amd64.deb -o /tmp/dnscontrol.deb \
    && apt install --no-install-recommends /tmp/dnscontrol.deb -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /dns
ADD . .
RUN make preview

VOLUME ["/dns/data"]
