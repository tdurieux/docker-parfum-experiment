FROM nvidia/cuda:9.0-cudnn7-devel

RUN apt-get update && \
    apt-get -y --no-install-recommends install software-properties-common build-essential python-dev git wget curl nginx openssh-server libgtk2.0-dev libnuma-dev && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get -y --no-install-recommends install python3.6-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;

# install pip
RUN cd /tmp && \
     curl -f -O https://bootstrap.pypa.io/get-pip.py && \
     python2 get-pip.py 'pip<=18.1' && \
     python3.6 get-pip.py 'pip<=18.1' && \
     rm get-pip.py

# CUDA-aware OpenMPI:
# 2.1.2 is recommended by Chainer.
RUN cd /tmp && \
        wget "https://www.open-mpi.org/software/ompi/v2.1/downloads/openmpi-2.1.2.tar.gz" && \
        tar xzf openmpi-2.1.2.tar.gz && \
        cd openmpi-2.1.2 && \
        ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-cuda && make all && make -j"$(nproc)" install && ldconfig && rm -rf /tmp/* && rm openmpi-2.1.2.tar.gz

RUN echo "hwloc_base_binding_policy = none" >> /usr/local/etc/openmpi-mca-params.conf && \
    echo "rmaps_base_mapping_policy = slot" >> /usr/local/etc/openmpi-mca-params.conf

ENV LD_LIBRARY_PATH=/usr/local/openmpi/lib:$LD_LIBRARY_PATH

ENV PATH /usr/local/openmpi/bin/:$PATH
ENV PATH=/usr/local/nvidia/bin:$PATH

ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1

# SSH. Partially taken from https://docs.docker.com/engine/examples/running_ssh_service/
RUN mkdir /var/run/sshd && \
  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
  mkdir -p /root/.ssh/ && \
  ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa && \
  cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
  printf "Host *\n  StrictHostKeyChecking no\n" >> /root/.ssh/config

COPY changehostname.c /
COPY change-hostname.sh /usr/local/bin/change-hostname.sh

RUN chmod +x /usr/local/bin/change-hostname.sh

# Patch fixes hanging issue with MultiProcessParallelUpdater.
# This patch is applied in final images.
# From https://github.com/chainer/chainer/pull/4756
COPY parallel_updater.patch /parallel_updater.patch
