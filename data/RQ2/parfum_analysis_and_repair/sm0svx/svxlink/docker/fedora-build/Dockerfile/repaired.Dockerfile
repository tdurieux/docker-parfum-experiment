# Build with:
#   docker build --pull -t svxlink-fedora-build .
#
# Run with:
#   docker run -it --rm --hostname fedora-build svxlink-fedora-build
#
# For using sound inside the docker container add:
#              --privileged -v /dev/snd:/dev/snd
#              -e HOSTAUDIO_GID=$(stat -c "%g" /dev/snd/timer)
#
# To import your git config add (mileage may vary):
#              -v ${HOME}/.gitconfig:/home/svxlink/.gitconfig:ro
#
# To use a specific git repositoty instead of the default one:
#              -e GIT_URL=username@your.repo:/path/to/svxlink.git
#
# To build another branch than master:
#              -e GIT_BRANCH=the_branch
#
# To use more than one CPU core when compiling:
#              -e NUM_CORES=8
#

FROM fedora
MAINTAINER Tobias Blomberg <sm0svx@ssa.se>

# Install required packages and set up the svxlink user
RUN dnf -y install git sudo cmake make gcc gcc-c++ libsigc++20-devel \
           alsa-lib-devel speex-devel opus-devel qt-devel rtl-sdr-devel \
           popt-devel libgcrypt-devel tcl-devel gsm-devel libcurl-devel \
           doxygen alsa-utils wget tar bzip2 \
           vim-enhanced && \
    dnf clean all

# Install svxlink audio files
RUN mkdir -p /usr/share/svxlink/sounds && \
    cd /usr/share/svxlink/sounds && \
    wget https://github.com/sm0svx/svxlink-sounds-en_US-heather/releases/download/14.08/svxlink-sounds-en_US-heather-16k-13.12.tar.bz2 && \
    tar xvaf svxlink-sounds-* && \
    ln -s en_US-heather-16k en_US && \
    rm svxlink-sounds-*

# Set up password less sudo for user svxlink
ADD sudoers-svxlink /etc/sudoers.d/svxlink
RUN chmod 0440 /etc/sudoers.d/svxlink

ENV GIT_URL=https://github.com/sm0svx/svxlink.git \
    GIT_BRANCH=master \
    NUM_CORES=1

RUN useradd svxlink
ADD build-svxlink.sh /home/svxlink/
RUN chown -R svxlink.svxlink /home/svxlink

#CMD ["/bin/bash"]