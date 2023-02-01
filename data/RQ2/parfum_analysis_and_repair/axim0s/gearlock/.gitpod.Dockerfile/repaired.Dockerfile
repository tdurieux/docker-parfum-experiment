FROM gitpod/workspace-full

RUN sudo apt-get update && \
    sudo apt install --no-install-recommends -y rsync cpio && rm -rf /var/lib/apt/lists/*;