FROM kaixhin/torch:latest
MAINTAINER Zeming Lin <zlin@fb.com>

### X11 server: inspired by suchja/x11server and suchja/wine ###

# first create user and group for all the X Window stuff
# required to do this first so we have consistent uid/gid between server and client container
RUN addgroup --system torchcraft \
  && adduser \
    --home /home/torchcraft \
    --disabled-password \
    --shell /bin/bash \
    --gecos "user for running an torcraft application" \
    --ingroup torchcraft \
    --quiet \
    torchcraft

# Install packages required for connecting against X Server
RUN apt-get update && apt-get install -y --no-install-recommends \
  xvfb \
  xauth \
  x11vnc \
  x11-utils \
  x11-xserver-utils && rm -rf /var/lib/apt/lists/*;

# Install packages for building the image
RUN apt-get update -y \
  && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    software-properties-common \
    vim \
  && add-apt-repository ppa:ubuntu-wine/ppa && rm -rf /var/lib/apt/lists/*;

# Define which versions we need
ENV WINE_MONO_VERSION 4.5.6
ENV WINE_GECKO_VERSION 2.40

# Install wine and related packages
RUN dpkg --add-architecture i386 \
  && apt-get update -y \
  && apt-get install -y --no-install-recommends \
    wine1.8 \
    wine-gecko$WINE_GECKO_VERSION:i386 \
    wine-gecko$WINE_GECKO_VERSION:amd64 \
    wine-mono$WINE_MONO_VERSION \
  && rm -rf /var/lib/apt/lists/*

# Use the latest version of winetricks
RUN curl -f -SL 'https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks' -o /usr/local/bin/winetricks \
&& chmod +x /usr/local/bin/winetricks

# Wine really doesn't like to be run as root, so let's use a non-root user
RUN adduser torchcraft sudo
RUN echo 'torchcraft:starcraft' | chpasswd

ENV WINEPREFIX /home/torchcraft/.wine
ENV WINEARCH win32
# Use torchcraft's home dir as working dir
WORKDIR /home/torchcraft

RUN echo "alias winegui='wine explorer /desktop=DockerDesktop,1024x768'" > /home/torchcraft/.bash_aliases

ENV DISPLAY :0.0
RUN echo "#!/bin/bash" >> /entrypoint.sh
RUN echo "Xvfb :0 -auth ~/.Xauthority -screen 0 1024x768x24 >>~/xvfb.log 2>&1 &" >> /entrypoint.sh
RUN echo "x11vnc -forever -passwd mot2pass -display :0 >> ~/xvnc.log 2>&1 &" >> /entrypoint.sh
RUN echo "exec \"\$@\"" >> /entrypoint.sh
RUN chmod +x /entrypoint.sh


### Starcraft stuff ###
# export torch variables for torchcraft
ENV LUA_PATH='/root/.luarocks/share/lua/5.1/?.lua;/root/.luarocks/share/lua/5.1/?/init.lua;/root/torch/install/share/lua/5.1/?.lua;/root/torch/install/share/lua/5.1/?/init.lua;./?.l
ENV LUA_CPATH='/root/.luarocks/lib/lua/5.1/?.so;/root/torch/install/lib/lua/5.1/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so'
ENV PATH=/root/torch/install/bin:$PATH
ENV LD_LIBRARY_PATH=/root/torch/install/lib:$LD_LIBRARY_PATH
ENV DYLD_LIBRARY_PATH=/root/torch/install/lib:$DYLD_LIBRARY_PATH
ENV LUA_CPATH='/root/torch/install/lib/?.so;'$LUA_CPATH

RUN git clone https://github.com/TorchCraft/TorchCraft
RUN cd ./TorchCraft; luarocks make *.rockspec

RUN curl -f -L https://ftp.blizzard.com/pub/broodwar/patches/PC/BW-1161.exe -o /home/torchcraft/BW-1161.exe
RUN curl -f -L https://github.com/bwapi/bwapi/releases/download/v4.2.0/BWAPI_420_Setup.exe -o /home/torchcraft/BWAPI_420_Setup.exe

RUN chown -R torchcraft:torchcraft /root
RUN chmod -R 777 /root
RUN chown -R torchcraft:torchcraft /home/torchcraft/TorchCraft
RUN chmod -R 777 /home/torchcraft/TorchCraft

USER torchcraft
ADD common/* ./
RUN echo ". /root/torch/install/bin/torch-activate" >> ~/.bashrc

ENTRYPOINT ["/entrypoint.sh"]
