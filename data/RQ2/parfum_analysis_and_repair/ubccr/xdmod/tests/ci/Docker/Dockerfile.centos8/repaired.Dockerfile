FROM tools-ext-01.ccr.xdmod.org/centos8.4:xdmod-base

ENV BRANCH=xdmod10.0
ENV REL=10.0
ENV BUILD=1.0
ENV TERM=xterm-256color
ENV XDMOD_TEST_MODE=fresh_install

LABEL description="The main XDMoD image used in our CI builds or local testing."

# We have some caches that we put in place for automated builds.
# This will copy them into place if they exist
COPY assets /tmp/assets
RUN /tmp/assets/copy-caches.sh
COPY bin /root/bin

# Copy mariadb
RUN mv /root/bin/mariadb-wait-ready /usr/libexec/

# Generate SSL Key
RUN openssl genrsa -rand /proc/cpuinfo:/proc/dma:/proc/filesystems:/proc/interrupts:/proc/ioports:/proc/uptime 2048 > /etc/pki/tls/private/localhost.key

# Generate SSL Certificate
RUN /usr/bin/openssl req -new -key /etc/pki/tls/private/localhost.key -x509 -sha256 -days 365 -set_serial $RANDOM -extensions v3_req -out /etc/pki/tls/certs/localhost.crt -subj "/C=XX/L=Default City/O=Default Company Ltd"

# Setup the base mysql db dir
RUN mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql


# Create the directory that XDMoD RPM will be built / saved to.
RUN mkdir -p /root/rpmbuild/RPMS/noarch

# Checkout the latest XDMoD branch
RUN git clone --single-branch --depth=1 https://github.com/ubccr/xdmod/ --branch $BRANCH /root/xdmod

# buildrpm requires us to start the script from the directory that we checked XDMoD out to.
WORKDIR /root/xdmod

# Make sure that we install XDMoD's dependencies before building the RPM.
RUN composer install

# Build the XDMoD RPM that will be installed in this docker image.
RUN /root/bin/buildrpm xdmod

# Install / Upgrade based on the XDMOD_TEST_MODE env variable.
RUN /root/xdmod/tests/ci/bootstrap.sh

# Clean everything up
RUN yum clean all
RUN rm -rf /var/cache/yum /root/xdmod /root/rpmbuild

WORKDIR /