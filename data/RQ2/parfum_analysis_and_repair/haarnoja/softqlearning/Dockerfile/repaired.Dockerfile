FROM ubuntu:16.04


# ========== Anaconda ==========
# https://github.com/ContinuumIO/docker-images/blob/master/anaconda/Dockerfile
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion && rm -rf /var/lib/apt/lists/*;

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda2-5.0.1-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

RUN apt-get install --no-install-recommends -y curl grep sed dpkg && \
    TINI_VERSION=$( curl -f https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:') && \
    curl -f -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

ENV PATH /opt/conda/bin:$PATH


# ========== Special Deps ==========
RUN apt-get -y --no-install-recommends install git make cmake unzip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir awscli
# ALE requires zlib
RUN apt-get -y --no-install-recommends install zlib1g-dev && rm -rf /var/lib/apt/lists/*;
# MUJOCO requires graphics stuff (Why?)
RUN apt-get -y build-dep glfw
RUN apt-get -y --no-install-recommends install libxrandr2 libxinerama-dev libxi6 libxcursor-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim ack-grep && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
# usual pip install pygame will fail
RUN apt-get build-dep -y python-pygame
RUN pip install --no-cache-dir Pillow


# ========== Add codebase stub ==========
WORKDIR /root/sql

ADD environment.yml /root/sql/environment.yml
RUN conda env create -f /root/sql/environment.yml \
    && conda env update

ENV PYTHONPATH /root/sql:$PYTHONPATH
ENV PATH /opt/conda/envs/sql/bin:$PATH
RUN echo "source activate sql" >> /root/.bashrc
ENV BASH_ENV /root/.bashrc


# ========= rllab ===============
# We need to clone rllab repo in order to use the
# `rllab.sandbox.rocky.tf` functions.

ENV RLLAB_PATH=/root/rllab \
    RLLAB_VERSION=b3a28992eca103cab3cb58363dd7a4bb07f250a0

RUN git clone https://github.com/rll/rllab.git ${RLLAB_PATH} \
    && cd ${RLLAB_PATH} \
    && git checkout ${RLLAB_VERSION} \
    && mkdir ${RLLAB_PATH}/vendor/mujoco \
    && python -m rllab.config

ENV PYTHONPATH ${RLLAB_PATH}:${PYTHONPATH}


# ========= MuJoCo ===============
ENV MUJOCO_VERSION=1.3.1 \
    MUJOCO_PATH=/root/.mujoco

RUN MUJOCO_ZIP="mjpro$(echo ${MUJOCO_VERSION} | sed -e "s/\.//g")_linux.zip" \
    && mkdir -p ${MUJOCO_PATH} \
    && wget -P ${MUJOCO_PATH} https://www.roboti.us/download/${MUJOCO_ZIP} \
    && unzip ${MUJOCO_PATH}/${MUJOCO_ZIP} -d ${MUJOCO_PATH} \
    && cp ${MUJOCO_PATH}/mjpro131/bin/libmujoco131.so ${RLLAB_PATH}/vendor/mujoco/ \
    && cp ${MUJOCO_PATH}/mjpro131/bin/libglfw.so.3 ${RLLAB_PATH}/vendor/mujoco/ \
    && rm ${MUJOCO_PATH}/${MUJOCO_ZIP}
