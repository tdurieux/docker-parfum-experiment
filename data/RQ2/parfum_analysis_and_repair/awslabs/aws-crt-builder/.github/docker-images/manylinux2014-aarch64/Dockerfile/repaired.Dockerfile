# See: https://github.com/pypa/manylinux
# and: https://github.com/pypa/python-manylinux-demo
FROM quay.io/pypa/manylinux2014_aarch64

###############################################################################
# Basics
###############################################################################
RUN yum -y install sudo \
    && yum clean all \
    && cmake --version \
    && ctest --version && rm -rf /var/cache/yum

###############################################################################
# Python/AWS CLI
###############################################################################
RUN /opt/python/cp39-cp39/bin/python -m pip install --upgrade pip setuptools virtualenv \
    && /opt/python/cp39-cp39/bin/python -m pip install --upgrade awscli \
    && ln -s `find /opt -name aws` /usr/local/bin/aws \
    && which aws \
    && aws --version

###############################################################################
# nodejs/npm
###############################################################################
RUN curl -f -sL https://rpm.nodesource.com/setup_12.x | sudo bash -
RUN sudo yum -y install nodejs && node --version && rm -rf /var/cache/yum

###############################################################################
# Install entrypoint
###############################################################################
ADD entrypoint.sh /usr/local/bin/builder
RUN chmod a+x /usr/local/bin/builder
ENTRYPOINT ["/usr/local/bin/builder"]
