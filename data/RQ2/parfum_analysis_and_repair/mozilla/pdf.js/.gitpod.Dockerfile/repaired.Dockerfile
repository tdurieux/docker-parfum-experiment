FROM gitpod/workspace-full-vnc

USER gitpod

RUN sudo apt-get update && \
    sudo apt-get install --no-install-recommends -yq firefox && \
    sudo rm -rf /var/lib/apt/lists/*
