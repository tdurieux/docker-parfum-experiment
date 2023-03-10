#--------------------------------------------------------------------------------------------------
# This dockerfile builds a minimal centos-based image for running a sanity smoketest during the
# automated release process.
#
# It requires the same files/assets as the unified smoke/unit Dockerfile
#
# Example build command:
#   docker build -f <thisfile> -t scalyr/scalyr-agent-ci-sanity:centos.1 .
#--------------------------------------------------------------------------------------------------

FROM centos

RUN yum install -y epel-release && yum install -y python36 python36-pip && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir requests
RUN yum install -y perl && rm -rf /var/cache/yum
RUN yum install -y sudo && rm -rf /var/cache/yum

#------------------------------------------------------
# Copy and run test scripts
#------------------------------------------------------
COPY unittest smoketest /tmp/
