#!/usr/bin/env python3
# Copyright 2004-present Facebook. All Rights Reserved.

FROM quay.io/pypa/manylinux2014_x86_64

# Install devtoolset-9
RUN yum install -y centos-release-scl
RUN yum install -y devtoolset-9
RUN echo "source /opt/rh/devtoolset-9/enable" >> /etc/bashrc
SHELL ["/bin/bash", "--login", "-c"]
RUN g++ --version

# Install Python, Java, wget, vim
RUN yum install -y python2 python36 python36-devel wget java-1.8.0-openjdk \
    java-1.8.0-openjdk-devel vim

# Install Ant
WORKDIR "/tmp"
RUN wget https://downloads.apache.org/ant/binaries/apache-ant-1.10.12-bin.zip
RUN unzip apache-ant-1.10.12-bin.zip \
    && mv apache-ant-1.10.12/ /opt/ant \
    && ln -s /opt/ant/bin/ant /usr/bin/ant

# Download Buck
WORKDIR "/opt"
RUN git clone https://github.com/facebook/buck.git

# Set JAVA_HOME
ENV JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk"

# Build Buck
WORKDIR "/opt/buck"
RUN ant
Run ln -s /opt/buck/bin/buck /usr/bin/buck

# Install Watchman
WORKDIR "/opt/watchman"
RUN wget https://github.com/facebook/watchman/releases/download/v2020.09.21.00/watchman-v2020.09.21.00-linux.zip
RUN unzip watchman-v2020.09.21.00-linux.zip
WORKDIR "/opt/watchman/watchman-v2020.09.21.00-linux"
RUN mkdir -p /usr/local/{bin,lib} /usr/local/var/run/watchman
RUN cp bin/* /usr/local/bin
RUN cp lib/* /usr/local/lib
RUN chmod 755 /usr/local/bin/watchman
RUN chmod 2777 /usr/local/var/run/watchman

# Copy LabGraph files
WORKDIR "/opt/labgraph"
COPY . .

# Build LabGraph Wheel
RUN python3.6 setup_py36.py install --user
RUN python3.6 setup_py36.py sdist bdist_wheel
RUN python3.6 -m pip install auditwheel
RUN auditwheel repair dist/*whl -w dist/

# Test LabGraph
RUN python3.6 -m pytest --pyargs -v labgraph._cthulhu
RUN python3.6 -m pytest --pyargs -v labgraph.events
RUN python3.6 -m pytest --pyargs -v labgraph.graphs
RUN python3.6 -m pytest --pyargs -v labgraph.loggers
RUN python3.6 -m pytest --pyargs -v labgraph.messages
RUN python3.6 -m pytest --pyargs -v labgraph.runners.tests.test_process_manager
RUN python3.6 -m pytest --pyargs -v labgraph.runners.tests.test_aligner
RUN python3.6 -m pytest --pyargs -v labgraph.runners.tests.test_cpp
RUN python3.6 -m pytest --pyargs -v labgraph.runners.tests.test_exception
RUN python3.6 -m pytest --pyargs -v labgraph.runners.tests.test_launch
RUN python3.6 -m pytest --pyargs -v labgraph.runners.tests.test_runner
