# Base image for tests. This differs from the deploy image in that
# rather than downloading source code from github it instead adds
# it from a tar file creaetd by test/travis-ci/install.sh

FROM ubuntu:xenial
RUN apt-get update
RUN apt-get -y --no-install-recommends install apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git cmake build-essential autoconf curl libtool python-dev python-numpy python-pip libboost-all-dev unzip graphviz && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir ipython funcsigs subprocess32 protobuf colorama graphviz
RUN pip install --no-cache-dir --upgrade git+git://github.com/cloudpipe/cloudpickle.git@0d225a4695f1f65ae1cbb2e0bbc145e10167cce4# We use the latest version of cloudpickle because it can serialize named tuples.
RUN adduser --gecos --ingroup ray-user --disabled-login --gecos ray-user
RUN adduser ray-user sudo
RUN sed -i "s|%sudo\tALL=(ALL:ALL) ALL|%sudo\tALL=NOPASSWD: ALL|" /etc/sudoers
ADD ray.tar /home/ray-user/ray
RUN chown -R ray-user.ray-user /home/ray-user/ray
USER ray-user
WORKDIR /home/ray-user/ray
RUN ./setup.sh
RUN ./build.sh
