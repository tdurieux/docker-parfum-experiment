# /usr/local/bin/start.sh will start the service

{% if base_os == "rhel7" %}
FROM openshifttools/oso-rhel7-ops-base:latest
{% elif base_os == "centos7" %}
FROM openshifttools/oso-centos7-ops-base:latest
{% endif %}

# Pause indefinitely if asked to do so.
ARG OO_PAUSE_ON_BUILD
RUN test "$OO_PAUSE_ON_BUILD" = "true" && while sleep 10; do true; done || :

EXPOSE 8080

USER 1001

COPY dashboard/ /usr/local/bin/

# Start processes