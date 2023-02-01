# Minimal Dockerfile for faster local development on Fedora. Requires
# `make image-hive-fedora-dev-base` run once to establish the base OS
# image, after which this Dockerfile can be used to add the binaries
# compiled on your local system with go caching. 

FROM hive-fedora-dev-base:latest

ADD bin/hiveadmission /opt/services/
ADD bin/operator /opt/services/hive-operator
ADD bin/manager /opt/services/
ADD bin/hiveutil /usr/bin/

# TODO: should this be the operator?