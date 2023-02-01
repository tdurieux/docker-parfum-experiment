FROM nvidia/cuda:9.2-devel

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y wget bzip2 git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libqglviewer-dev cmake && rm -rf /var/lib/apt/lists/*;

RUN mkdir /home/odometry
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /home/odometry/miniconda.sh
RUN bash /home/odometry/miniconda.sh -b -p /home/odometry/miniconda
RUN rm /home/odometry/miniconda.sh

ADD conda.yml conda.yml

RUN /home/odometry/miniconda/bin/conda env create -n odometry -f conda.yml

RUN apt-get install -y --no-install-recommends locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US

RUN git clone https://github.com/uoip/g2opy.git /home/odometry/g2opy
RUN apt-get install --no-install-recommends -y libeigen3-dev libsuitesparse-dev && rm -rf /var/lib/apt/lists/*;
RUN /home/odometry/miniconda/bin/conda install pybind11
RUN PATH=/home/odometry/miniconda/envs/odometry/bin:$PATH && \
    cd /home/odometry/g2opy && \
    mkdir build && \
    cd build && \
    cmake -DPYBIND11_PYTHON_VERSION=3.6 .. && \
    make -j8 && \
    cd .. && \
    python setup.py install
