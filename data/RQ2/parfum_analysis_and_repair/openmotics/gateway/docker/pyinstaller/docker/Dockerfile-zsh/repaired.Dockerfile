FROM arm32v7/python:3.6-stretch
LABEL description="Test qemu build"
LABEL name="qemu-emulator"
LABEL version="0.6"

# Needed to build arm dockers
COPY qemu-arm-static /usr/bin

# Creating a build folder for container build files
RUN mkdir -p /build
WORKDIR /build

# RUN apt update && apt install -y zip rsyslog socat sshpass libusb-1.0.0-dev
RUN apt update -y && \
	apt install --no-install-recommends -y \
		wget \
		vim \
		zsh \
		sudo \
		git \
		zip && rm -rf /var/lib/apt/lists/*;

# Set timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Brussels /etc/localtime

# install requirements in the container
COPY requirements.txt /build
RUN pip install --no-cache-dir -r requirements.txt



# Adding develop user
RUN useradd --create-home --shell /bin/bash "developer"
RUN adduser developer sudo
RUN echo "developer:dev" | chpasswd
RUN echo "ALL ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers

USER developer


# install oh-my-zsh
WORKDIR /home/developer
RUN wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh && \
	sh install.sh
COPY default-zshrc /home/developer/.zshrc
WORKDIR /build

# change ownership of the .zshrc file
USER root
RUN chown developer /home/developer/.zshrc
USER developer

# ENTRYPOINT /usr/sbin/rsyslogd \
#            && bash
