# Build on centos_javabridge by installing software that is required
# for building the javabridge but not for testing it.

FROM centos_javabridge
MAINTAINER Lee Kamentsky,leek@broadinstitute.org

RUN yum install -y git
# Copied from https://raw.github.com/pypa/pip/master/contrib/get-pip.py
ADD get-pip.py /tmp/get-pip.py
RUN python /tmp/get-pip.py
RUN pip install cython