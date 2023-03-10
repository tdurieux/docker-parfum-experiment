#--------------------------------------------------------------------
# Build Pytorch & Torchvision Wheels on Centos
#--------------------------------------------------------------------
FROM centos:8 as wheel-builder
LABEL maintainer=otc-swstacks@intel.com

RUN yum update -y \
    && yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && yum install -y jemalloc-devel wget git python3-pip python3 python36-devel.x86_64 \
    && dnf -y install gcc-toolset-9-gcc gcc-toolset-9-gcc-c++ \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip && rm -rf /var/cache/yum

ENV PATH=/opt/rh/gcc-toolset-9/root/usr/bin:$PATH

WORKDIR buildir
COPY scripts/torch_utils.sh common/requirements.txt dataloader.patch_v1.8.0-rc2 .
RUN pip --no-cache-dir install -r requirements.txt wheel \
    && ./torch_utils.sh

RUN cd /buildir/pytorch \
    && python setup.py bdist_wheel -d /torch-wheels && python setup.py install

RUN cd /buildir/vision \
    && python setup.py bdist_wheel -d /torch-wheels

#--------------------------------------------------------------------
# [CORE] Pytorch & Torchvision CPU on Centos
#--------------------------------------------------------------------
FROM centos:8 as centos-core
LABEL maintainer=otc-swstacks@intel.com

RUN yum update -y \
    && yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && yum install -y jemalloc python3-pip python3 python3-devel libgomp \
    && dnf -y install gcc-toolset-9-gcc \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip && rm -rf /var/cache/yum

ENV PATH=/opt/rh/gcc-toolset-9/root/usr/bin:$PATH

COPY --from=wheel-builder /torch-wheels /torch-wheels
RUN pip --no-cache-dir install torch-wheels/* \
    && rm -rf /torch-wheels

WORKDIR workspace
COPY scripts/generate_defaults.py common/requirements.txt .
RUN pip --no-cache-dir install --no-deps \
    -r requirements.txt \
    && rm -rf ./requirements.txt

RUN python generate_defaults.py --generate \
    && cat mkl_env.sh >> /etc/bash.bashrc \
    && rm -rf /workspace/* \
    && chmod -R a+w /workspace

COPY ./licenses/ /workspace/licenses

SHELL ["/bin/bash",  "-c"]

#--------------------------------------------------------------------
# [FULL] Base Frameworks and Add-ons CPU on Centos
#--------------------------------------------------------------------
FROM centos-core as centos-full-base
LABEL maintainer=otc-swstacks@intel.com

RUN yum install -y epel-release http://rpms.remirepo.net/enterprise/remi-release-8.rpm \
    python3-devel libjpeg-devel zlib-devel openmpi openmpi-devel make mesa-libGL git wget \
    && dnf -y install gcc-toolset-9-gcc-c++ && rm -rf /var/cache/yum

ENV PATH=/usr/lib64/openmpi/bin:$PATH

COPY common/frameworks.txt scripts/install_addons.sh .
RUN pip install --no-cache-dir --upgrade pip \
    && HOROVOD_WITH_PYTORCH=1 pip --no-cache-dir install horovod==0.21.1 \
    && pip --no-cache-dir install \
    -r frameworks.txt \
    && ./install_addons.sh \
    && rm -rf /workspace/*

RUN yum remove -y python3-devel zlib-devel make git wget \
    gcc-toolset-9-gcc-c++

COPY ./licenses /workspace/licenses
#--------------------------------------------------------------------
# [FULL] Frameworks and Add-ons CPU on Centos
#--------------------------------------------------------------------
FROM centos:8 as centos-full
LABEL maintainer=otc-swstacks@intel.com

COPY --from=centos-full-base / /

# add default paths to be exposed
RUN mkdir -p /etc/profile.d/ \
    && touch /etc/profile.d/sources.sh \
    && echo "export PATH=$PATH:/usr/lib64/openmpi/bin:/usr/lib64" >> /etc/profile.d/sources.sh \
    && echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64" >> /etc/profile.d/sources.sh \
    && chmod +x /etc/profile.d/sources.sh

SHELL ["/bin/bash",  "-c"]
