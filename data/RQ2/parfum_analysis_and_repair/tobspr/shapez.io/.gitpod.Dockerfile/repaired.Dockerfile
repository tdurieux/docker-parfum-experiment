FROM gitpod/workspace-full

RUN sudo apt-get update \
    && sudo apt install --no-install-recommends ffmpeg -yq && rm -rf /var/lib/apt/lists/*;
