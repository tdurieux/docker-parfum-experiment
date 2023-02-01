FROM gitpod/workspace-full-vnc

WORKDIR /workspace/Minecraft-Box-Launcher
USER root

# Install Electron dependencies.
RUN sudo apt-get update \
	&& sudo apt-get install --no-install-recommends -y \
	libasound2-dev \
	libgtk-3-dev \
	libnss3-dev \
	&& sudo rm -rf /var/lib/apt/lists/*

USER gitpod
RUN npm install && npm cache clean --force;

USER root
