FROM registry.access.redhat.com/ubi8:latest

RUN dnf install -y --nodocs git python3 python3-pip gcc python3-devel gcc-c++ atlas-devel gcc-gfortran
RUN dnf install -y --nodocs procps-ng iproute net-tools ethtool nmap iputils
RUN ln -s /usr/bin/python3 /usr/bin/python
ADD https://api.github.com/repos/distributed-system-analysis/smallfile/git/refs/heads/master /tmp/bustcache
RUN git clone https://github.com/distributed-system-analysis/smallfile /opt/smallfile --depth 1
RUN ln -sv /opt/smallfile/smallfile_cli.py /usr/local/bin/
RUN ln -sv /opt/smallfile/smallfile_rsptimes_stats.py /usr/local/bin/
RUN python3 -m pip install --upgrade cython numpy importlib_metadata 'urllib3!=1.25.0,!=1.25.1,<1.26,>=1.21.1' && python3 -m pip install --upgrade scipy pandas
COPY . /opt/snafu/
RUN pip3 install --no-cache-dir -e /opt/snafu/
