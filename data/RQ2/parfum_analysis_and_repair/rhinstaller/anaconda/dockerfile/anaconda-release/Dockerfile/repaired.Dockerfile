# Dockerfile to enable releases of Anaconda for RHEL independently of the host system.
#
# This will be based on our existing anaconda-rpm container because it has all the dependencies
# required to build Anaconda.

ARG image
FROM ${image}
LABEL maintainer=anaconda-list@redhat.com

# Add missing dependencies required to do the build.