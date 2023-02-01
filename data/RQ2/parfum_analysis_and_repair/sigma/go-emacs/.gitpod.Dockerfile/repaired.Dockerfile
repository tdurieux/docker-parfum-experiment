FROM gitpod/workspace-full

USER gitpod

RUN sudo apt-get -q update && \
  sudo apt-get install --no-install-recommends -yq emacs && \
  sudo rm -rf /var/lib/apt/lists/*
