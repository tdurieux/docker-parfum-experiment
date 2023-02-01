#
# OpenDKIM server
#

FROM gcr.io/mcback/base:latest

# Install packages
RUN \


    apt-get -y --no-install-recommends install opendkim opendkim-tools && \
    true && rm -rf /var/lib/apt/lists/*;

# Configure OpenDKIM socket
RUN sed -i -e "s/^SOCKET=.*/SOCKET='inet:12301'/" /etc/default/opendkim

# Remove vendor configuration
RUN rm -rf /etc/opendkim/ /etc/opendkim.conf

COPY etc/opendkim.conf /etc/
COPY etc/opendkim/ /etc/opendkim/

# Copy TrustedHosts somewhere so that we could overwrite it in a volume with a wrapper script
COPY etc/opendkim/TrustedHosts /var/lib/opendkim-TrustedHosts

# OpenDKIM port
EXPOSE 12301

# Volume with configuration and keys
VOLUME /etc/opendkim/

# Copy wrapper script
COPY bin/opendkim.sh /

# No USER because daemon will demote itself to "opendkim" user itself

CMD ["/opendkim.sh"]
