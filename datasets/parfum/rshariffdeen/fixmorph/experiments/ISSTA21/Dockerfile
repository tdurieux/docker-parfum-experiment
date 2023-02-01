FROM rshariffdeen/fixmorph:16.04
MAINTAINER Ridwan Shariffdeen <ridwan@comp.nus.edu.sg>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    bc \
    gtk+-3.0 \
    libavahi-client-dev \
    libasound2-dev \
    libgconf2-dev \
    libconfig-dev \
    libcrypto++-dev \
    libdaemon-dev \
    libelf-dev \
    libfreetype6-dev \
    libidn2-0-dev \
    libjbig-dev \
    libjbig2dec0-dev \
    libnl-3-dev \
    libnl-genl-3-dev \
    libopenjp2-7-dev \
    libpopt-dev \
    libpulse-dev \
    libsoxr-dev \
    libssl-dev \
    libtiff5-dev \
    mesa-common-dev \
    libboost-all-dev \
    libgoogle-perftools-dev \
    libncurses5-dev \
    tzdata


RUN git config --global user.email "rshariffdeen@gmail.com"
RUN git config --global user.name "Ridwan"
ADD $PWD /experiment
WORKDIR /FixMorph

# Tidy up the container
RUN DEBIAN_FRONTEND=noninteractive apt-get -y autoremove && apt-get clean && \
     rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
