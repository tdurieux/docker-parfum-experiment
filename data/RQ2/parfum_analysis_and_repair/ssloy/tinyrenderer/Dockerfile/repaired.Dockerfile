FROM gitpod/workspace-full

USER root
# add your tools here
RUN apt-get update && apt-get install --no-install-recommends -y \
  imagemagick && rm -rf /var/lib/apt/lists/*;
