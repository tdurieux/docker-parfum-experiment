FROM gitpod/workspace-full

USER gitpod

RUN sudo apt-get -q update && \
    sudo apt-get install --no-install-recommends -yq autoconf automake libtool pkg-config bear python-pytest && \
    sudo rm -rf /var/lib/apt/lists/*
