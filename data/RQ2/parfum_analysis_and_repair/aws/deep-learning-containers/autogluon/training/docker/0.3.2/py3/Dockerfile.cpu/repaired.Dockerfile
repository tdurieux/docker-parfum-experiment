ARG FROM_IMAGE=ubuntu:18.04
FROM ${FROM_IMAGE}

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

ARG OPENSSL_VERSION=1.1.1l
ARG PYTHON_VERSION=3.8.12
ARG PYTHON=python3
ARG MXNET_VER=1.9.*
ARG TORCH_VER=1.8.0+cpu
ARG TORCH_VISION_VER=0.9.0+cpu

ARG AUTOGLUON_VERSION=0.3.1

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    SAGEMAKER_TRAINING_MODULE=sagemaker_mxnet_container.training:main \
    DEBIAN_FRONTEND="noninteractive" \
    TZ="UTC"

# Install dependencies
RUN apt-get update \
 && apt-get -y upgrade \
 && apt-get install -y --no-install-recommends \
    gcc \
    build-essential \
    wget \
    curl \
    emacs \
    git \
    vim \
    unzip \
    zlib1g-dev \
    libssl-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libgl1-mesa-glx \
    libffi-dev \
    liblzma-dev \
    libbz2-dev \
    libsqlite3-dev \
    tk-dev \
    uuid-dev \
    ca-certificates \
    libopencv-dev \
    openssh-client \
    openssh-server \
    libreadline-gplv2-dev \
    libc6-dev \
    cmake \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# install OpenSSL
RUN wget -q -c https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz \
 && tar -xzf openssl-${OPENSSL_VERSION}.tar.gz \
 && cd openssl-${OPENSSL_VERSION} \
 && ./config && make -j $(nproc) && make install \
 && ldconfig \
 && cd .. && rm -rf openssl-* \
 && rmdir /usr/local/ssl/certs \
 && ln -s /etc/ssl/certs /usr/local/ssl/certs && rm openssl-${OPENSSL_VERSION}.tar.gz

# Install Open MPI
RUN mkdir /tmp/openmpi \
 && cd /tmp/openmpi \
 && wget -q https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.1.tar.gz \
 && tar zxf openmpi-4.0.1.tar.gz \
 && cd openmpi-4.0.1 \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-orterun-prefix-by-default \
 && make -j $(nproc) all \
 && make install \
 && ldconfig \
 && cd /tmp && rm -rf /tmp/openmpi && rm openmpi-4.0.1.tar.gz

# Create a wrapper for OpenMPI to allow running as root by default
RUN mv /usr/local/bin/mpirun /usr/local/bin/mpirun.real \
 && echo '#!/bin/bash' > /usr/local/bin/mpirun \
 && echo 'mpirun.real --allow-run-as-root "$@"' >> /usr/local/bin/mpirun \
 && chmod a+x /usr/local/bin/mpirun \
 && echo "hwloc_base_binding_policy = none" >> /usr/local/etc/openmpi-mca-params.conf \
 && echo "rmaps_base_mapping_policy = slot" >> /usr/local/etc/openmpi-mca-params.conf

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
ENV PATH=/usr/local/bin:$PATH

# install Python
RUN wget -q https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
 && tar -xzf Python-$PYTHON_VERSION.tgz \
 && cd Python-$PYTHON_VERSION \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-shared --prefix=/usr/local \
 && make -j $(nproc) && make install \
 && cd .. && rm -rf ../Python-$PYTHON_VERSION* \
 && ln -s /usr/local/bin/pip3 /usr/bin/pip \
 && ln -s /usr/local/bin/$PYTHON /usr/local/bin/python \
 && pip --no-cache-dir install --upgrade --trusted-host pypi.org --trusted-host files.pythonhosted.org pip \
 && pip --no-cache-dir install --upgrade wheel setuptools && rm Python-$PYTHON_VERSION.tgz

WORKDIR /

RUN pip install --no-cache-dir -U \
    torch==${TORCH_VER} torchvision==${TORCH_VISION_VER} -f https://download.pytorch.org/whl/torch_stable.html \
    mxnet==${MXNET_VER} \
    autogluon==${AUTOGLUON_VERSION} \
    sagemaker-mxnet-training \
 && pip uninstall -y \ 
    datashader \
    ipykernel \
    ipython \
    ipython-genutils \
    ipywidgets \
    jupyter-client \
    jupyter-core \
    jupyter-packaging \
    jupyter-server \
    jupyter-server-proxy \
    jupyterlab \
    jupyterlab-nvdashboard \
    jupyterlab-pygments \
    jupyterlab-server \
    jupyterlab-widgets \
    matplotlib-inline \
    nbclient \
    nbconvert \
    nbformat \
    notebook \
    panel \
    pydeck \
    pyppeteer \
    traitlets \
    websockets \
    widgetsnbextension \
 && rm -rf /tmp/* \
 && rm -rf /root/.viminfo

# Catboost 0.26 updates version of scala 2.11 for security reasons
# https://github.com/catboost/catboost/issues/1632
# Dask security patching
RUN pip install --no-cache-dir -U catboost==0.26.1 \
 && pip install --no-cache-dir -U "dask>2021.09.1" "distributed>2021.09.1" \
 && pip install --no-cache-dir -U 'numpy>=1.21,<1.22' \
 && pip install --no-cache-dir -U 'Pillow>=9.0.1,<9.1.0'


# Allow OpenSSH to talk to containers without asking for confirmation
RUN cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new \
 && echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new \
 && mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config

# OpenSHH config for MPI communication
RUN mkdir -p /var/run/sshd && \
  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN rm -rf /root/.ssh/ \
 && mkdir -p /root/.ssh/ \
 && ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa \
 && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys \
 && printf "Host *\n StrictHostKeyChecking no\n" >> /root/.ssh/config

# This is here to make our installed version of OpenCV work.
# https://stackoverflow.com/questions/29274638/opencv-libdc1394-error-failed-to-initialize-libdc1394
# TODO: Should we be installing OpenCV in our image like this? Is there another way we can fix this?
RUN ln -s /dev/null /dev/raw1394

RUN HOME_DIR=/root \
 && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
 && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
 && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
 && chmod +x /usr/local/bin/testOSSCompliance \
 && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
 && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
 && rm -rf ${HOME_DIR}/oss_compliance*

RUN curl -f -o /license.txt https://autogluon.s3.us-west-2.amazonaws.com/licenses/THIRD-PARTY-LICENSES.txt

CMD ["/bin/bash"]
