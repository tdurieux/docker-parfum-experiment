FROM debian

RUN apt-get update && apt-get install --no-install-recommends -y maven xterm libnotify-bin && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y dbus-x11 x11-utils x11-xserver-utils xfce4 --no-install-recommends && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y xfce4-terminal mousepad xfce4-notifyd --no-install-recommends && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y libxv1 mesa-utils mesa-utils-extra libgl1-mesa-glx libglew2.0 \
                       libglu1-mesa libgl1-mesa-dri libdrm2 libgles2-mesa libegl1-mesa --no-install-recommends && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "startxfce4" ]
