FROM dockercask/base
MAINTAINER Zachary Huff <zach.huff.386@gmail.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install --assume-yes xserver-xorg-video-intel mesa-utils && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install --assume-yes libcairo2 libfreetype6 fontconfig && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install --assume-yes light-themes human-icon-theme gnome-human-icon-theme && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install --assume-yes xauth xfce4 xfce4-notifyd lxappearance gtk2-engines gtk2-engines-aurora gtk2-engines-murrine gtk3-engines-xfce xcursor-themes dmz-cursor-theme && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository --yes ppa:numix/ppa
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install --assume-yes numix-gtk-theme && rm -rf /var/lib/apt/lists/*;
