FROM nvidia/cuda:7.5-cudnn4-devel-ubuntu14.04

# ========== Anaconda ==========
# https://github.com/ContinuumIO/docker-images/blob/master/anaconda/Dockerfile
RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion && rm -rf /var/lib/apt/lists/*;
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget  --no-check-certificate --quiet https://repo.continuum.io/archive/Anaconda2-2.5.0-Linux-x86_64.sh && \
    /bin/bash /Anaconda2-2.5.0-Linux-x86_64.sh -b -p /opt/conda && \
    rm /Anaconda2-2.5.0-Linux-x86_64.sh

RUN apt-get install --no-install-recommends -y curl grep sed dpkg && \
    TINI_VERSION=$( curl -f https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:') && \
    curl -f -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

ENV PATH /opt/conda/bin:$PATH
# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# ========== Upgrade pip ==========
RUN pip install --no-cache-dir --upgrade pip
RUN apt-get -y --no-install-recommends install git make cmake unzip apt-utils && rm -rf /var/lib/apt/lists/*;

# ========== SUMO ==========
ENV SUMO_VERSION 0.27.1
ENV SUMO_SRC sumo-src-$SUMO_VERSION
ENV SUMO_HOME /opt/sumo

# Install system dependencies.
RUN apt-get update && apt-get -y --no-install-recommends install -qq \
    g++ libxerces-c3.1 libxerces-c3-dev \
    libproj-dev proj-bin proj-data libtool libgdal1-dev \
    libfox-1.6-0 libfox-1.6-dev && rm -rf /var/lib/apt/lists/*;

# Download and extract source code
RUN wget https://downloads.sourceforge.net/project/sumo/sumo/version%20$SUMO_VERSION/sumo-src-$SUMO_VERSION.tar.gz
RUN tar xzf sumo-src-$SUMO_VERSION.tar.gz && \
    mv sumo-$SUMO_VERSION $SUMO_HOME && \
    rm sumo-src-$SUMO_VERSION.tar.gz

# Apply patch file
RUN cd $SUMO_HOME && wget https://www.dropbox.com/s/23dam05ugg73jny/sumo-departure-time.patch && patch -p1 < sumo-departure-time.patch

# Configure and build from source.
RUN cd $SUMO_HOME && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install

# RUN echo "export PYTHONPATH=\"/opt/sumo/sumo-$SUMO_VERSION/tools\"" >> /root/.bashrc
ENV PYTHONPATH $SUMO_HOME/tools:$PYTHONPATH

# Ensure the installation works. If this call fails, the whole build will fail.
RUN sumo

# Download and compile traci4j library, not sure if necessary
# RUN apt-get install -qq -y ssh-client git
# RUN mkdir -p /opt/traci4j
# WORKDIR /opt/traci4j
# RUN git clone https://github.com/egueli/TraCI4J.git /opt/traci4j && mvn package -Dmaven.test.skip=true

# Expose a port so that SUMO can be started with --remote-port 8873 to be controlled from outside Docker
EXPOSE 8873

# CMD ["--help"]
ENTRYPOINT [ "/usr/bin/tini", "--" ] # "sumo"

# ========== Special Deps ==========
RUN pip install --no-cache-dir awscli
# ALE requires zlib
RUN apt-get -y --no-install-recommends install zlib1g-dev && rm -rf /var/lib/apt/lists/*;
# MUJOCO requires graphics stuff (Why?)
RUN apt-get -y build-dep glfw
RUN apt-get -y --no-install-recommends install libxrandr2 libxinerama-dev libxi6 libxcursor-dev && rm -rf /var/lib/apt/lists/*;
# copied from requirements.txt
#RUN pip install imageio tabulate nose
RUN apt-get install --no-install-recommends -y vim ack-grep && rm -rf /var/lib/apt/lists/*;
# usual pip install pygame will fail
RUN apt-get build-dep -y python-pygame
RUN pip install --no-cache-dir Pillow

# ========== OpenAI Gym ==========
RUN apt-get -y --no-install-recommends install libgtk2.0-0 && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir gym
#RUN apt-get -y install ffmpeg
RUN apt-get -y --no-install-recommends install libav-tools && rm -rf /var/lib/apt/lists/*;
CMD alias ffmpeg="avconv"

# ========== Add codebase stub ==========
CMD mkdir /root/code
ADD environment.yml /root/code/environment.yml
RUN conda env create -f /root/code/environment.yml

ENV PYTHONPATH /root/code/rllab:$PYTHONPATH
ENV PATH /opt/conda/envs/rllab3/bin:$PATH
RUN echo "source activate rllab3" >> /root/.bashrc
ENV BASH_ENV /root/.bashrc
WORKDIR /root/code

# gpu theanno
ENV THEANO_FLAGS mode=FAST_RUN,device=gpu,floatX=float32
