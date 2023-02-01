FROM gitpod/workspace-full

USER gitpod

RUN sudo apt-get -q update && \
    sudo apt-get install --no-install-recommends -yq autoconf automake bear libjansson-dev && \
    sudo rm -rf /var/lib/apt/lists/*
