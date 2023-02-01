FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
	build-essential \
	ca-certificates \
	cmake \
	git \
	iproute2 \
	locales \
	pandoc \
	software-properties-common \
	wget \
	vim && \
	rm -rf /var/lib/apt/lists/* \
    /etc/apt/sources.list.d/cuda.list \
	/etc/apt/sources.list.d/nvidia-ml.list


RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN add-apt-repository ppa:deadsnakes/ppa && \
	apt-get update && apt-get install -y --no-install-recommends \
	python3.6 \
	python3.6-dev \
	libatlas-base-dev \
	graphviz 

RUN wget -O ~/get-pip.py \
    https://bootstrap.pypa.io/get-pip.py && \
    python3.6 ~/get-pip.py && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python3 && \
	ln -s /usr/bin/python3.6 /usr/local/bin/python

RUN python -m pip --no-cache-dir install --upgrade \
        setuptools \
        numpy \
        scipy \
        pandas \
        scikit-learn \
        matplotlib \
		Cython \
		mxnet-cu90 \
		graphviz \
		fire \
		toolz \
		jupyter \
		ipykernel \
		papermill 


RUN ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
	rm -rf /var/lib/apt/lists/* /tmp/* ~/*


RUN git clone https://github.com/msalvaris/gpu_monitor.git && \
	pip install -r gpu_monitor/requirements.txt && \
	pip install -e gpu_monitor



