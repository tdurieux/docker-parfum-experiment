# Image name: daqf/faux2
#
# Faux device for framework development/testing.
#

FROM daqf/aardvark:latest

# Run this separately so it can be shared with other builds.
RUN $AG update && $AG install openjdk-11-jre
RUN $AG update && $AG install openjdk-11-jdk git
RUN $AG update && $AG install isc-dhcp-client ethtool network-manager netcat curl \
    python3.8 ifupdown openssl ssh nano apache2-utils ntpdate

# Additional OS dependencies
RUN $AG update && $AG install -y telnetd && $AG install xinetd nginx

# Prefetch resolvconf to dynamically install at runtime in start_faux.
RUN $AG update && cd /tmp && ln -s ~/bin bin && $AG download resolvconf && mv resolvconf_*.deb ~

# Default to python3
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 2

# Basic faux stuff
COPY docker/include/bin/start_faux docker/include/bin/failing bin/

# Weird workaround for problem running tcdump in a privlidged container.