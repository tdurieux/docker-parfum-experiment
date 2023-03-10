FROM registry.access.redhat.com/ubi8:latest

RUN dnf install -y --nodocs git python3 python3-pip gcc python3-devel gcc-c++ atlas-devel gcc-gfortran
RUN dnf install -y --nodocs procps-ng iproute net-tools ethtool nmap iputils
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN python3 -m pip install --upgrade cython numpy importlib_metadata 'urllib3!=1.25.0,!=1.25.1,<1.26,>=1.21.1' && python3 -m pip install --upgrade scipy pandas
COPY . /opt/snafu/
RUN pip3 install --no-cache-dir -e /opt/snafu/
ADD https://api.github.com/repos/parallel-fs-utils/fs-drift/git/refs/heads/master /tmp/bustcache
RUN git clone https://github.com/parallel-fs-utils/fs-drift /opt/fs-drift --depth 1
RUN ln -sv /opt/fs-drift/fs-drift.py /usr/local/bin/
RUN ln -sv /opt/fs-drift/rsptime_stats.py /usr/local/bin/
