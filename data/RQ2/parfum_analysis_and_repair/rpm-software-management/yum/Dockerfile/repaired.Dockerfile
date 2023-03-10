# YUM development image

FROM centos:7

# Set up EPEL
RUN yum install -y \
        epel-release && rm -rf /var/cache/yum

# Install useful stuff
RUN yum install -y \
        python-pip \
        python-ipdb \
        ipython \
        vim \
        less && rm -rf /var/cache/yum
RUN rpm -e --nodeps yum
RUN rm -rf /var/cache/yum
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir pudb

# Use the yum checkout mounted from the host
ENV PATH=/src/bin:$PATH \
    PYTHONPATH=/src:$PYTHONPATH
RUN ln -s /src/etc/yum.conf /etc/yum.conf
RUN ln -s /src/etc/version-groups.conf /etc/yum/version-groups.conf

VOLUME ["/src"]
ENTRYPOINT ["/bin/bash"]
