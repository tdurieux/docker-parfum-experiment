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
RUN apt-get update
RUN apt-get -y --no-install-recommends install git make cmake unzip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir awscli
# ALE requires zlib
RUN apt-get -y --no-install-recommends install zlib1g-dev && rm -rf /var/lib/apt/lists/*;
# MUJOCO requires graphics stuff (Why?)
RUN apt-get -y build-dep glfw
RUN apt-get -y --no-install-recommends install libxrandr2 libxinerama-dev libxi6 libxcursor-dev && rm -rf /var/lib/apt/lists/*;
# copied from requirements.txt
#RUN pip install imageio tabulate nose
RUN apt-get install --no-install-recommends -y vim ack-grep && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
# usual pip install pygame will fail
RUN apt-get build-dep -y python-pygame
RUN pip install --no-cache-dir Pillow
RUN apt install --no-install-recommends -y libopenmpi-dev && rm -rf /var/lib/apt/lists/*;

# ========== OpenAI Gym ==========
RUN apt-get -y --no-install-recommends install libgtk2.0-0 && rm -rf /var/lib/apt/lists/*;
#RUN apt-get -y install ffmpeg
RUN apt-get -y --no-install-recommends install libav-tools && rm -rf /var/lib/apt/lists/*;
CMD alias ffmpeg="avconv"

# ========== Setup mujoco ========
CMD mkdir /root/.mujoco
RUN wget https://www.roboti.us/download/mjpro150_linux.zip
RUN unzip mjpro150_linux.zip -d /root/.mujoco
ADD mjkey.txt /root/.mujoco/mjkey.txt
RUN apt-get install --no-install-recommends -y libgl1-mesa-dev libgl1-mesa-glx libglew-dev libosmesa6-dev && rm -rf /var/lib/apt/lists/*;

# ========= Cassie Environment ===========
RUN apt-get install --no-install-recommends -y llvm-5.0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libglfw3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y clang-5.0 && rm -rf /var/lib/apt/lists/*;

# ========== Add codebase stub ==========
CMD mkdir /root/code
ADD environment.yml /root/code/environment.yml
RUN conda env create -f /root/code/environment.yml

#RUN conda uninstall -y tensorflow
#RUN pip install tensorflow

ENV PYTHONPATH /root/code/rllab:$PYTHONPATH
ENV LD_LIBRARY_PATH /root/.mujoco/mjpro150/bin:$LD_LIBRARY_PATH
ENV PATH /opt/conda/envs/rllab3/bin:$PATH
RUN echo "source activate rllab3" >> /root/.bashrc
ENV BASH_ENV /root/.bashrc
WORKDIR /root/code

# gpu theanno
ENV THEANO_FLAGS mode=FAST_RUN,device=gpu,floatX=float32
