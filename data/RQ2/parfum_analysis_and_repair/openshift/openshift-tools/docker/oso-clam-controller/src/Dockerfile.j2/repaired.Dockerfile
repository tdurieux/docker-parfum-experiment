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

RUN yum install -y python2-boto3 \
                   systemd-python \
                   python-requests \
                   openscap-scanner \
                   python34 \
                   python34-libs \
                   python34-PyYAML \
		   python34-requests \
                   python2-botocore && \
    yum clean all && rm -rf /var/cache/yum

ADD scripts/ /usr/local/bin/

EXPOSE 8080

# run as root user
USER 0

# Start processes
CMD /usr/local/bin/start.sh
