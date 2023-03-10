FROM registry.access.redhat.com/ubi8:latest

RUN curl -f -L https://github.com/brianfrankcooper/YCSB/releases/download/0.15.0/ycsb-0.15.0.tar.gz | tar xz && mv ycsb-0.15.0 ycsb
RUN dnf install -y --nodocs https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf install -y --nodocs git java python3 python2 python3-pip procps-ng iproute net-tools ethtool nmap iputils gcc python3-devel gcc-c++ atlas-devel gcc-gfortran && dnf clean all
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN python3 -m pip install --upgrade cython numpy importlib_metadata 'urllib3!=1.25.0,!=1.25.1,<1.26,>=1.21.1' && python3 -m pip install --upgrade scipy pandas
COPY . /opt/snafu/
RUN pip3 install --no-cache-dir -e /opt/snafu/
