FROM digitalrebar/deploy-service-wrapper
MAINTAINER Victor Lowther <victor@rackn.com>

ARG DR_TAG

# Get packages
RUN apt-get update \
  && apt-get -y --no-install-recommends install bind9 bind9utils dnsutils \
  && mkdir -p /etc/dns-mgmt.d \
  && mkdir -p /var/cache/rebar-dns-mgmt \
  && chmod 700 /var/cache/rebar-dns-mgmt \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Set our command
ENTRYPOINT ["/sbin/docker-entrypoint.sh"]
ADD http://localhost:28569/${DR_TAG}/linux/amd64/rebar-dns-mgmt /usr/local/bin/rebar-dns-mgmt
RUN chmod 755 /usr/local/bin/rebar-dns-mgmt
COPY dns-mgmt.d/* /etc/dns-mgmt.d/
COPY bind /etc/bind
COPY entrypoint.d/*.sh /usr/local/entrypoint.d/
