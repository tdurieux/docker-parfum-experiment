FROM thewtex/opengl:latest
MAINTAINER Matt McCormick <matt.mccormick@kitware.com>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
  mesa-utils && rm -rf /var/lib/apt/lists/*;

ENV APP "glxgears"
