FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install opennebula-common and rubygems
COPY --from=ghcr.io/kvaps/opennebula-packages:v5.12.0.4-1 /packages/opennebula-common_*.deb /packages/ruby-opennebula_*_all.deb /packages/opennebula-tools_*.deb /packages/opennebula-rubygems_*.deb /packages/opennebula-common-onescape_*.deb /packages/
RUN apt-get update \
 && ln -s /bin/true /usr/bin/systemd-tmpfiles \
 && apt-get -y --no-install-recommends install /packages/*.deb \
 && mkdir -p /var/log/one /var/lock/one /var/run/one \
 && apt-get -y clean \
 && rm -rf /var/lib/apt/lists/ \
 && chown oneadmin: /var/log/one /var/lock/one /var/run/one && rm -rf /var/lib/apt/lists/*;

# Logging to stdout
RUN for i in oned.log sched.log onehem.log sunstone.log novnc.log onegate.log oneflow.log; do ln -sf "/proc/1/fd/1" "/var/log/one/$i"; done

# Install opennebula
COPY --from=ghcr.io/kvaps/opennebula-packages:v5.12.0.4-1 /packages/opennebula-gate_*.deb /packages/
RUN apt-get -y update \
 && apt-get -y --no-install-recommends install /packages/opennebula-gate_*.deb \
 && rm -f /usr/bin/systemd-tmpfiles \
 && apt-get -y clean \
 && rm -rf /var/lib/apt/lists/ && rm -rf /var/lib/apt/lists/*;

# Fix permissions
RUN chown -R oneadmin:oneadmin /etc/one

USER oneadmin
ENTRYPOINT [ "/usr/bin/ruby", "/usr/lib/one/onegate/onegate-server.rb" ]
