FROM registry.redhat.io/rhel8/httpd-24

# Add application sources
ADD . /tmp/src

# Assemble script installs the dependencies
# TODO: describe what assemble does, and link to https://docs.openshift.com/container-platform/3.11/creating_images/s2i.html
RUN /usr/libexec/s2i/assemble

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run