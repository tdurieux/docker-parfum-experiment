# gibson graphical sample provided with the CUDA toolkit.

# docker build -t gibson .
# docker run --runtime=nvidia -ti --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix gibson

FROM nvidia/cudagl:9.0-runtime-ubuntu16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-samples-$CUDA_PKG_VERSION && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/cuda/samples/5_Simulations/nbody

RUN make

#CMD ./nbody

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

# Install miniconda to /miniconda
RUN curl -f -LO http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
RUN bash Miniconda-latest-Linux-x86_64.sh -p /miniconda -b
RUN rm Miniconda-latest-Linux-x86_64.sh
ENV PATH=/miniconda/bin:${PATH}
RUN conda update -y conda
RUN conda create -y -n py35 python=3.5
# Python packages from conda

ENV PATH /miniconda/envs/py35/bin:$PATH

RUN pip install --no-cache-dir http://download.pytorch.org/whl/cu90/torch-0.3.1-cp35-cp35m-linux_x86_64.whl
RUN pip install --no-cache-dir torchvision==0.2.0
RUN pip install --no-cache-dir tensorflow==1.3

WORKDIR /root

RUN apt-get install --no-install-recommends -y git build-essential cmake libopenmpi-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/fxia22/baselines.git && \
	pip install --no-cache-dir -e baselines

RUN apt-get update && apt-get install --no-install-recommends -y \
		libglew-dev \
		libglm-dev \
		libassimp-dev \
		xorg-dev \
		libglu1-mesa-dev \
		libboost-dev \
		mesa-common-dev \
		freeglut3-dev \
		libopenmpi-dev \
		cmake \
		golang \
		libjpeg-turbo8-dev \
		wmctrl \
		xdotool \
		&& \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/cache/apk/* && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y vim wget unzip && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libzmq3-dev && rm -rf /var/lib/apt/lists/*;

ADD  . /root/mount/gibson
WORKDIR /root/mount/gibson

RUN bash build.sh build_local
RUN pip install --no-cache-dir -e .

ENV QT_X11_NO_MITSHM 1

