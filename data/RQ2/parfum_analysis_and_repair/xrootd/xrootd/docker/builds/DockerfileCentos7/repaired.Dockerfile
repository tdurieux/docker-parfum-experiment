FROM centos:7
MAINTAINER Michal Simon <michal.simon@cern.ch>, CERN, 2015

USER root
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y gcc-c++ rpm-build which git python-srpm-macros centos-release-scl vim && rm -rf /var/cache/yum
RUN git clone https://github.com/xrootd/xrootd
WORKDIR /xrootd/packaging
RUN ./makesrpm.sh --define "_with_python3 1" --define "_with_tests 1" --define "_with_xrdclhttp 1" --define "_with_scitokens 1" --define "_with_isal 1"
RUN yum-builddep -y *.src.rpm
RUN rm -f *src.rpm
WORKDIR /xrootd/build
ENTRYPOINT scl enable devtoolset-7 bash

