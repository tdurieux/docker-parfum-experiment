FROM gitpod/workspace-full-vnc

RUN sudo apt-get update \
 && sudo apt-get install --no-install-recommends -y \
  libasound2-dev \
  libgtk-3-dev \
  fish \
  libnss3-dev && rm -rf /var/lib/apt/lists/*;