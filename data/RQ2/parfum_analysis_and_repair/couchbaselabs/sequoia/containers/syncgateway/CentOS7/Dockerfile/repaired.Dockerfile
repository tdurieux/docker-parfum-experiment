FROM centos/systemd

ARG VERSION=1.4.1
ARG BUILD_NO=3

ENV PATH $PATH:/opt/couchbase-sync-gateway/bin
ENV PKG couchbase-sync-gateway-enterprise_${VERSION}-${BUILD_NO}_x86_64.rpm

# Install dependencies:
#  wget: for downloading Sync Gateway package installer
RUN yum -y update && \
    yum install -y \
    wget perl && \
    yum clean all && rm -rf /var/cache/yum

# Install Sync Gateway
RUN wget https://latestbuilds.service.couchbase.com/builds/latestbuilds/sync_gateway/$VERSION/$BUILD_NO/$PKG && \
    rpm -i $PKG && \
    rm $PKG

# Create directory where the default config stores memory snapshots to disk
RUN mkdir /opt/couchbase-sync-gateway/data

# Add the default config into the container
ADD config/config.json /home/sync_gateway/sync_gateway.json

ADD entrypoint.sh /entrypoint.sh

# Expose ports
#  port 4984: public port
EXPOSE 4984

# Invoke the sync_gateway executable by default
CMD ["/usr/sbin/init"]
