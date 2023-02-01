FROM debian:jessie

RUN apt-get update
RUN apt-get install --no-install-recommends -yq twm xterm xserver-xorg-video-vesa && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yq xserver-xorg-input-all xserver-xorg-input-kbd xserver-xorg-input-mouse xserver-xorg-video-intel && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yq vim-tiny && rm -rf /var/lib/apt/lists/*;

COPY start.sh /
COPY xorg.conf /

CMD /start.sh
