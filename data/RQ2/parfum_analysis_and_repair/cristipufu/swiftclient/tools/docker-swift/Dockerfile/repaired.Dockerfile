FROM ubuntu:14.04
MAINTAINER Stefan Prodan

RUN apt-get update && apt-get install --no-install-recommends -y supervisor swift python-swiftclient rsync \
                       swift-proxy swift-object memcached python-keystoneclient \
                       python-swiftclient swift-plugin-s3 python-netifaces \
                       python-xattr python-memcache \
                       swift-account swift-container swift-object pwgen && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /var/log/supervisor
ADD files/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#
# Swift configuration
# - Partially fom http://docs.openstack.org/developer/swift/development_saio.html
#

# not sure how valuable dispersion will be...
ADD files/dispersion.conf /etc/swift/dispersion.conf
ADD files/rsyncd.conf /etc/rsyncd.conf
ADD files/swift.conf /etc/swift/swift.conf
ADD files/proxy-server.conf /etc/swift/proxy-server.conf
ADD files/account-server.conf /etc/swift/account-server.conf
ADD files/object-server.conf /etc/swift/object-server.conf
ADD files/container-server.conf /etc/swift/container-server.conf
ADD files/proxy-server.conf /etc/swift/proxy-server.conf
ADD files/startmain.sh /usr/local/bin/startmain.sh
RUN chmod 755 /usr/local/bin/*.sh

EXPOSE 8080

CMD /usr/local/bin/startmain.sh
