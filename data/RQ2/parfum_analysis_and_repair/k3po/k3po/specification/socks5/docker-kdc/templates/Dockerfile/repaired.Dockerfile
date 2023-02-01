FROM ubuntu:14.04

RUN apt-get -y update

ADD krb5.conf /etc/krb5.conf

RUN apt-get -y --no-install-recommends install heimdal-kdc && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libsasl2-modules-gssapi-heimdal && rm -rf /var/lib/apt/lists/*;

EXPOSE	10088

# Create keytab folder.
RUN mkdir /etc/docker-kdc

# Add kerberos principal/s.
PRINCIPALS

# Export keytab.
EXPORT_KEYTAB

# KDC daemon startup.
ENTRYPOINT ["/usr/lib/heimdal-servers/kdc", "--config-file=/etc/heimdal-kdc/kdc.conf", "-P 10088"]
