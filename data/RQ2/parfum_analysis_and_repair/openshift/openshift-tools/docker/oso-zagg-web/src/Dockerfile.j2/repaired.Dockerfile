{{ generated_header }}
# Example docker run command
# docker run -p 80:80 -p 443:443 oso-rhel7-zagg-web
# /root/start.sh will then start the mysqldb, zabbix, and httpd services.
# Default login:password to Zabbix is Admin:zabbix

{% if base_os == "rhel7" %}
FROM oso-rhel7-ops-base:latest
{% elif base_os == "centos7" %}
FROM openshifttools/oso-centos7-ops-base:latest
{% endif %}

# Pause indefinitely if asked to do so.
ARG OO_PAUSE_ON_BUILD
RUN test "$OO_PAUSE_ON_BUILD" = "true" && while sleep 10; do true; done || :

RUN yum clean metadata && \
    yum-install-check.sh -y iproute iputils \
        python2-passlib \
        python-openshift-tools-monitoring-zagg \
        openshift-tools-web-zagg \
        python-openshift-tools-zbxapi \
        openshift-tools-scripts-monitoring-zagg-server \
        redis python2-redis \
        tree httpd mod_ssl mod_wsgi \
        telnet bind-utils net-tools iproute && \
    yum clean all

ADD root /root

EXPOSE 8000 8443

# Start apache
ADD ops-run-in-loop start.sh /usr/local/bin/
CMD /usr/local/bin/start.sh

# Run apache in mpm_worker mode
ADD 00-mpm.conf /etc/httpd/conf.modules.d/

# RHEL7.2 Fix for mod_auth_digest writing to /run/httpd/authdigest_shm.pid
RUN sed -i -e 's/^\(LoadModule auth_digest_module modules\/mod_auth_digest.so\)$/#\1/g' /etc/httpd/conf.modules.d/00-base.conf

# Set default zabbix-server host
RUN sed -i -e 's/^g_default_zabbix_server.*/g_default_zabbix_server: oso-{{ base_os }}-zaio/g' /root/default_vars.yml

# Disable redis persistence, no use for us, container goes away it's lost anyway
RUN sed -i -e '/^save/ s/^/#/' /etc/redis.conf
RUN chmod 0755 /var/lib/redis

# Temporary fixes until we can run as root
# Make the container work more consistently in and out of openshift
# BE CAREFUL!!! If you change these, you may bloat the image! Use 'docker history' to see the size!
ADD ssl.conf /etc/httpd/conf.d/
ADD httpd.conf /etc/httpd/conf/
RUN chmod -R g+rwX /var/www/zagg /etc/httpd /etc/passwd /etc/openshift_tools /etc/ansible /run /var/log /etc/pki/tls/certs/localhost.crt /etc/pki/tls/private/localhost.key &&  \
    chgrp -R root /run /var/log