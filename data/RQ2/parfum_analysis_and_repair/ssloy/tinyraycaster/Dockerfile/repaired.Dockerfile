FROM gitpod/workspace-full-vnc

USER root
# add your tools here
RUN apt-get update && apt-get install --no-install-recommends -y \
  netpbm \
  libsdl2-dev && rm -rf /var/lib/apt/lists/*;
