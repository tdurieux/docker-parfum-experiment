FROM ubuntu:16.04

LABEL maintainer="Amazon AI"

ARG MX_URL=https://aws-mxnet-pypi.s3-us-west-2.amazonaws.com/1.6.0/aws_mxnet_mkl-1.6.0-py2.py3-none-manylinux1_x86_64.whl

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib" \
    PYTHONIOENCODING=UTF-8 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    SAGEMAKER_TRAINING_MODULE=sagemaker_mxnet_container.training:main

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    # build-essential needed to pip install user's dependencies (e.g. requirements.txt)
    build-essential \
    ca-certificates \
    curl \
    git \
    libopencv-dev \
    python \
    # python-dev needed to pip install mxnet and user's dependencies (e.g. requirements.txt)
    python-dev \
    python-pip \
    openssh-client \
    openssh-server \
    vim \
    wget \
    # zlib1g-dev needed to pip install sagemaker_mxnet_training
    zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && ln -s $(which python) /usr/local/bin/python

# MXNet requires pip 19.3.1 due to being backwards compatible
# with python2
RUN pip --no-cache-dir install --upgrade \
    pip==19.3.1 \
    setuptools

###########################################################################
# Horovod dependencies
###########################################################################

# Install Open MPI
RUN mkdir /tmp/openmpi \
 && cd /tmp/openmpi \
 && curl -fSsL -O https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.1.tar.gz \
 && tar zxf openmpi-4.0.1.tar.gz \
 && cd openmpi-4.0.1 \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-orterun-prefix-by-default \
 && make -j $(nproc) all \
 && make install \
 && ldconfig \
 && rm -rf /tmp/openmpi && rm openmpi-4.0.1.tar.gz

# Create a wrapper for OpenMPI to allow running as root by default
RUN mv /usr/local/bin/mpirun /usr/local/bin/mpirun.real \
 && echo '#!/bin/bash' > /usr/local/bin/mpirun \
 && echo 'mpirun.real --allow-run-as-root "$@"' >> /usr/local/bin/mpirun \
 && chmod a+x /usr/local/bin/mpirun

RUN echo "hwloc_base_binding_policy = none" >> /usr/local/etc/openmpi-mca-params.conf \
 && echo "rmaps_base_mapping_policy = slot" >> /usr/local/etc/openmpi-mca-params.conf

ENV LD_LIBRARY_PATH=/usr/local/openmpi/lib:$LD_LIBRARY_PATH
ENV PATH=/usr/local/openmpi/bin/:$PATH

WORKDIR /

# python-dateutil==2.8.0 to satisfy botocore
RUN pip install --no-cache-dir --no-cache --upgrade \
    keras-mxnet==2.2.4.2 \
    h5py==2.10.0 \


    "setuptools<45" \
    onnx==1.6.0 \
    numpy==1.16.5 \
    pandas==0.24.2 \
    Pillow==6.2.2 \
    requests==2.22.0 \
    scikit-learn==0.20.4 \
    scipy==1.2.2 \
    urllib3==1.25.8 \
    python-dateutil==2.8.0 \
    mpi4py==3.0.2 \
    ${MX_URL} \


    "inotify-simple<1.3" \
    "sagemaker-mxnet-training<4"

# Install Horovod
RUN pip install --no-cache-dir horovod==0.19.0

# Allow OpenSSH to talk to containers without asking for confirmation
RUN cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new \
 && echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new \
 && mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config

# "channels first" is recommended for keras-mxnet
# https://github.com/awslabs/keras-apache-mxnet/blob/master/docs/mxnet_backend/performance_guide.md#channels-first-image-data-format-for-cnn
RUN mkdir /root/.keras \
 && echo '{"image_data_format": "channels_first"}' > /root/.keras/keras.json

# This is here to make our installed version of OpenCV work.
# https://stackoverflow.com/questions/29274638/opencv-libdc1394-error-failed-to-initialize-libdc1394
# TODO: Should we be installing OpenCV in our image like this? Is there another way we can fix this?
RUN ln -s /dev/null /dev/raw1394

COPY dockerd-entrypoint.py /usr/local/bin/dockerd-entrypoint.py

RUN chmod +x /usr/local/bin/dockerd-entrypoint.py

RUN curl -f -o /license.txt https://aws-dlc-licenses.s3.amazonaws.com/aws-mxnet-1.6.0/license.txt

ENTRYPOINT ["python", "/usr/local/bin/dockerd-entrypoint.py"]
CMD ["/bin/bash"]
