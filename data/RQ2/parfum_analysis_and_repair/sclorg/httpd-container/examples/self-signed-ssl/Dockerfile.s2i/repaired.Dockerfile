FROM registry.redhat.io/rhel8/httpd-24

# Add application sources
ADD index.html /tmp/src/index.html

# Add self-signed certificate files
ADD httpd-ssl "/tmp/src/httpd-ssl"

# Assemble script installs the dependencies
# TODO: describe what assemble does, and link to https://docs.openshift.com/container-platform/3.11/creating_images/s2i.html
RUN /usr/libexec/s2i/assemble

USER 0
RUN sed -i -e '1 a\
set -x' /usr/bin/run-httpd
USER 1001

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run