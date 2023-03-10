# /usr/local/bin/start.sh will start the service

{% if base_os == "rhel7" %}
FROM openshifttools/oso-rhel7-ops-base:latest
{% elif base_os == "centos7" %}
FROM openshifttools/oso-centos7-ops-base:latest
{% endif %}

# Pause indefinitely if asked to do so.
ARG OO_PAUSE_ON_BUILD
RUN test "$OO_PAUSE_ON_BUILD" = "true" && while sleep 10; do true; done || :

# Add root folder
ADD root/ /root/

# Install clam server utilities and signature updater
RUN yum install -y clamav-server \
		   clamav-scanner \
		   clamav-unofficial-sigs \
		   openshift-tools-scripts-clam-update \
                   python2-pip \
		   python2-boto3 \
                   python2-botocore && \
    yum clean all && rm -rf /var/cache/yum

ADD scripts/ /usr/local/bin/

ADD clamd/ /etc/clamd.d/

# Make mount point for host filesystem and compile scanning utilities
RUN mkdir -p /host/var/run/clamd.scan && \
             pip install --no-cache-dir prometheus_client

# run as root user
USER 0

# Start processes
CMD /usr/local/bin/start.sh
