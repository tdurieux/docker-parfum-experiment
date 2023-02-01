FROM ubuntu:16.04

# ========== Anaconda ==========
# https://github.com/ContinuumIO/docker-images/blob/master/anaconda/Dockerfile
RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion && rm -rf /var/lib/apt/lists/*;
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget  --no-check-certificate --quiet https://repo.continuum.io/archive/Anaconda2-2.5.0-Linux-x86_64.sh && \
    /bin/bash /Anaconda2-2.5.0-Linux-x86_64.sh -b -p /opt/conda && \
    rm /Anaconda2-2.5.0-Linux-x86_64.sh

RUN apt-get update --fix-missing && apt-get -y --no-install-recommends install autotools-dev autoconf && rm -rf /var/lib/apt/lists/*;

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
ENTRYPOINT [ "/usr/bin/tini", "--" ]

# ========== Special Deps ==========
RUN apt-get -y --no-install-recommends install git make cmake unzip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir awscli
# ALE requires zlib
RUN apt-get -y --no-install-recommends install zlib1g-dev && rm -rf /var/lib/apt/lists/*;
# MUJOCO requires graphics stuff (Why?)
# RUN apt-get -y build-dep glfw
# RUN apt-get -y install libxrandr2 libxinerama-dev libxi6 libxcursor-dev
# copied from requirements.txt
# RUN pip install imageio tabulate nose
# RUN apt-get install -y vim ack-grep
# RUN pip install --upgrade pip
# usual pip install pygame will fail
# RUN apt-get build-dep -y python-pygame
# RUN pip install Pillow

# ========== SUMO =================

ENV SUMO_SRC sumo
ENV SUMO_HOME /opt/sumo

# Install system dependencies.
RUN apt-get update && apt-get -y --no-install-recommends install -qq \
    g++ libxerces-c3.1 libxerces-c3-dev \
    libproj-dev proj-bin proj-data libtool libgdal1-dev \
    libfox-1.6-0 libfox-1.6-dev && rm -rf /var/lib/apt/lists/*;


# Download SUMO nightly build
# Download SUMO nightly build
RUN git clone https://github.com/DLR-TS/sumo.git
RUN mv $SUMO_SRC $SUMO_HOME
RUN cd $SUMO_HOME && git checkout 1d4338ab80

RUN cd $SUMO_HOME && wget https://s3-us-west-1.amazonaws.com/cistar.patch/tmp.patch && patch -p1 < tmp.patch

# Install SUMO
RUN cd $SUMO_HOME && make -f Makefile.cvs && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j8 && make install

# RUN echo "export PYTHONPATH=\"/opt/sumo/sumo/tools\"" >> /root/.bashrc
ENV PYTHONPATH $SUMO_HOME/tools:$PYTHONPATH

# Ensure the installation works. If this call fails, the whole build will fail.
RUN sumo

# ========== OpenAI Gym ==========
RUN apt-get -y update --fix-missing
RUN apt-get -y --no-install-recommends install libgtk2.0-0 && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir gym
#RUN apt-get -y install ffmpeg
RUN apt-get -y --no-install-recommends install libav-tools && rm -rf /var/lib/apt/lists/*;
CMD alias ffmpeg="avconv"

# ========== Add codebase stub ==========
CMD mkdir /root/code
ADD environment.yml /root/code/environment.yml
RUN conda env create -f /root/code/environment.yml

ENV PYTHONPATH /root/code/rllab/flow:$PYTHONPATH
ENV PYTHONPATH /root/code/flow:$PYTHONPATH
ENV PYTHONPATH /root/code/rllab:$PYTHONPATH
ENV PYTHONPATH /root/code/rllab/learning-traffic:$PYTHONPATH
ENV PATH /opt/conda/envs/flow/bin:$PATH
RUN echo "source activate flow" >> /root/.bashrc
RUN echo "source activate flow"
ENV BASH_ENV /root/.bashrc
WORKDIR /root/code

RUN apt-get install --no-install-recommends -y libopenblas-dev && rm -rf /var/lib/apt/lists/*;
RUN printf "[blas]\nldflags = -lopenblas\n" > ~/.theanorc
RUN conda env list
