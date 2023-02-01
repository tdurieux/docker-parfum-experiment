ARG BASE_IMAGE=nvidia/cudagl:10.0-devel-ubuntu18.04
FROM $BASE_IMAGE

RUN apt-get update && apt-get install \
	git \
	libglu1-mesa-dev \
	pulseaudio \
	python3 \
	python3-pip \
	sudo \
	sudo \
	wget \
	x11-xserver-utils \
	xdg-user-dirs \
	unzip \
	-y --no-install-recommends && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir setuptools wheel
RUN pip3 install --no-cache-dir airsimneurips

RUN adduser --force-badname --disabled-password --gecos '' --shell /bin/bash airsim_user && \ 
	echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \ 
	adduser airsim_user sudo && \ 
	adduser airsim_user audio && \ 
	adduser airsim_user video

USER airsim_user
ENV USER airsim_user
WORKDIR /home/airsim_user
RUN sudo chown -R airsim_user /home/airsim_user

RUN git clone https://github.com/microsoft/AirSim-NeurIPS2019-Drone-Racing && \
	cd AirSim-NeurIPS2019-Drone-Racing && \
	bash download_training_binaries.sh && \
	bash download_qualification_binaries.sh && \
	mv AirSim_Training/ ../ && \
	mv AirSim_Qualification/ ../ && \
	cd ../