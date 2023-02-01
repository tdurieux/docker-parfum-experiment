FROM gitpod/workspace-full

RUN sudo apt-get update && \
    sudo apt-get install --no-install-recommends -y netcat-traditional socat && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*