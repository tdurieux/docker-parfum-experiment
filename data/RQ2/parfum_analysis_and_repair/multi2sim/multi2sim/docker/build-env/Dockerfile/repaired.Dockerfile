FROM ubuntu:14.04.5
MAINTAINER NUCAR

# Libs for build Multi2Sim
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y git build-essential automake autoconf libtool zlib1g-dev lib32gcc1 gcc-multilib libgtk-3-dev && rm -rf /var/lib/apt/lists/*;

