FROM gitpod/workspace-full-vnc

USER gitpod

RUN sudo apt-get -q update && \
    sudo apt-get install --no-install-recommends -yq libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev cloc && rm -rf /var/lib/apt/lists/*;
