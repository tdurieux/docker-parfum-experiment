{{ generated_header }}
# Example docker run command
# docker run -ti --net=host --name web --rm=true oso-{{ base_os }}-saml-sso
# /root/start.sh will then start the httpd.

{% if base_os == "rhel7" %}
FROM oso-rhel7-ops-base:latest
{% elif base_os == "centos7" %}
FROM openshifttools/oso-centos7-ops-base:latest
{% endif %}

# Pause indefinitely if asked to do so.
ARG OO_PAUSE_ON_BUILD
RUN test "$OO_PAUSE_ON_BUILD" = "true" && while sleep 10; do true; done || :

EXPOSE 8443

ADD start.sh /usr/local/bin/

# Install SimpleSAML and modules from RPMs, then run our setup/hardening script for SimpleSAML
RUN yum-install-check.sh -y \
        httpd \
        inotify-tools \
        mod_ssl \
        openssh-server \
        && \
    yum -y update && yum clean all


# Copy config files
ADD sshd_config /etc/ssh/sshd_config
ADD ssl.conf /etc/httpd/conf.d/ssl.conf

RUN chmod g+r /etc/pki/tls/certs/localhost.crt /etc/pki/tls/private/localhost.key

# Start apache & sshd
CMD /usr/local/bin/start.sh

# Add config file templates and startup playbook
ADD root/ /root/

# Setup /persistent
RUN mkdir -p /persistent

# Setup /configdata
RUN mkdir -p /configdata

# Fix v3 specific environment
# Make the container work more consistently in and out of openshift
# BE CAREFUL!!! If you change these, you may bloat the image! Use 'docker history' to see the size!
RUN mkdir -p /run/httpd && \
    chmod -R g+rwX /home /etc/httpd /etc/passwd /etc/group /run /var/log && \
    chgrp -R root /run/ /var/log && \
    ansible-playbook /root/build.yaml && \
    rm -rf /root/.ansible