# CSiBE-docker
#
# VERSION 0.0.1

FROM ubuntu:16.04
MAINTAINER Gabor Loki

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y build-essential bash git nano vim curl cmake clang python3 virtualenv python3-pip freeglut3-dev autoconf libfreetype6-dev libgl1-mesa-dri libglib2.0-dev xorg-dev gperf libssl-dev libbz2-dev libosmesa6-dev libxmu6 libxmu-dev libglu1-mesa-dev libgles2-mesa-dev libegl1-mesa-dev libdbus-1-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc-arm-none-eabi gcc-multilib && rm -rf /var/lib/apt/lists/*;

ENV USER=csibe
ENV SETUP=Dockerfile.setup.sh

# Fix for Clang
RUN ln -s /usr/include/asm-generic /usr/include/asm

RUN useradd -ms /bin/bash $USER

WORKDIR /home/$USER
COPY $SETUP .
RUN chown $USER:$USER $SETUP
RUN chmod u+x $SETUP

USER $USER

RUN ./$SETUP

CMD ["/bin/bash"]
