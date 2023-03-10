ARG BASE_IMAGE=nvidia/cudagl:10.0-devel-ubuntu18.04
FROM $BASE_IMAGE

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
	python3 \
	python3-pip \
	sudo \
	libglu1-mesa-dev \
	xdg-user-dirs \
	pulseaudio \
	x11-xserver-utils && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install --upgrade pip && \
    pip3 install --no-cache-dir setuptools wheel && \
    pip3 install --no-cache-dir airsim

RUN adduser --force-badname --disabled-password --gecos '' --shell /bin/bash airsim_user && \
	echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
	adduser airsim_user sudo && \
	adduser airsim_user audio && \
	adduser airsim_user video

USER airsim_user
WORKDIR /home/airsim_user

RUN mkdir -p /home/airsim_user/Documents/AirSim
COPY settings.json /home/airsim_user/Documents/AirSim
#ADD Documents /home/airsim_user/Documents

RUN sudo chown -R airsim_user /home/airsim_user
