# Environment to build and unit-test ngraph on centos74 for GPU backend
# with gcc 4.8.5
# with python 2.7
# with pre-built cmake3

FROM nvidia/cuda:8.0-cudnn7-devel-centos7

RUN yum -y update && \
    yum -y --enablerepo=extras install epel-release && \
    yum -y install \
    gcc gcc-c++ \
    cmake3 make \
    git \
    wget patch diffutils zlib-devel ncurses-devel libtinfo-dev \
    python python-devel python-setuptools \
    doxygen graphviz \
    which \
    'perl(Data::Dumper)' && rm -rf /var/cache/yum

RUN ln -s /usr/bin/cmake3 /usr/bin/cmake
RUN ln -s /usr/local/cuda/include/cudnn.h /usr/local/cuda/include/cudnn_v7.h

RUN cmake --version
RUN make --version
RUN gcc --version
RUN c++ --version

RUN easy_install pip
RUN pip install --no-cache-dir virtualenv==16.7.10

# Install some pip packages

# need to use sphinx version 1.6 to build docs
# installing with apt-get install python-sphinx installs sphinx version 1.3.6 only
# added install for python-pip above and
# installed sphinx with pip to get the updated version 1.6.5
# allows for make html build under the doc/source directory as an interim build process
RUN pip install --no-cache-dir sphinx

# breathe package required to build documentation
RUN pip install --no-cache-dir breathe

# need numpy to successfully build docs for python_api
RUN pip install --no-cache-dir numpy

# RUN python3 -m pip install m2r

WORKDIR /home
