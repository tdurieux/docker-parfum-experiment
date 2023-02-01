# https://gitlab.com/brinkervii/grapejuice/wikis/Installation/Ubuntu
# https://appdb.winehq.org/objectManager.php?sClass=application&iId=9392
{{#amd64}}
FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu18.04
{{/amd64}}

{{#arm32}}
FROM balenalib/raspberry-pi-debian:stretch-20191011
{{/arm32}}

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Install graphic driver
# RUN apt-get update -qy && apt-get install -qy \
RUN apt-get update -qy && apt-get install -qy --no-install-recommends \
      `# libEGL support` \
      libgl1-mesa-dri \
      mesa-utils && rm -rf /var/lib/apt/lists/*;

# Install Chromium
RUN apt install --no-install-recommends -y chromium-browser libcanberra-gtk-module libcanberra-gtk3-module && rm -rf /var/lib/apt/lists/*;
# Finish install Chromium

# Install Roblox
# https://gitlab.com/brinkervii/grapejuice/wikis/Installation/Ubuntu
# Install Wine
RUN dpkg --add-architecture i386 && \
    apt-get install --no-install-recommends -y software-properties-common wget && \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key -O /tmp/winehq.key && \
    apt-key add /tmp/winehq.key && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' && \
    apt update && \
    apt install --no-install-recommends --install-recommends -y wine-stable winbind && rm -rf /var/lib/apt/lists/*;
# Finish install Wine

# Install Python 3.7
RUN add-apt-repository -y ppa:deadsnakes/ppa && \
    apt install --no-install-recommends -y python3.7 python3.7-dev python3.7-venv && rm -rf /var/lib/apt/lists/*;
# Finish install Python 3.7

# Dependencies
RUN apt install --no-install-recommends -y python3-pip virtualenv libcairo2-dev libgirepository1.0-dev libgtk-3-0 libgtk-3-bin libdbus-1-dev python3-gi gobject-introspection gir1.2-gtk-3.0 && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;

# Install
# wget https://gitlab.com/brinkervii/grapejuice/-/archive/master/grapejuice-master.zip
COPY ./grapejuice-master.zip /tmp/grapejuice-master.zip
RUN cd /tmp && \
    unzip grapejuice-master.zip && \
    cd grapejuice-master && \
    python3.7 ./install.py

RUN apt install --no-install-recommends -y dbus-x11 && rm -rf /var/lib/apt/lists/*;
# Finish install Roblox

RUN useradd -ms /bin/bash roblox

WORKDIR /home/roblox

USER roblox

# RUN mkdir /home/roblox/.minecraft

COPY --chown=roblox ./docker-entrypoint.sh /
COPY --chown=roblox ./README.md /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["help"]
