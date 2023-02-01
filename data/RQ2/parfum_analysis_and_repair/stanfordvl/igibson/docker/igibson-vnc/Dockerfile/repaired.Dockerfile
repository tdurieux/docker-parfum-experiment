FROM igibson/igibson:latest

# add dummy display and remote GUI via x11VNC

RUN DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y \
    xserver-xorg-video-dummy \
    xfce4 desktop-base \
    x11vnc net-tools && rm -rf /var/lib/apt/lists/*;
# disable screensaver
RUN apt autoremove -y xscreensaver

# optional: if you want a richer desktop experience
RUN DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y \
    xfce4-terminal firefox && rm -rf /var/lib/apt/lists/*;
RUN echo 2 | update-alternatives --config x-terminal-emulator
# ==== end of optional =====

RUN mkdir -p /opt/misc /opt/logs
COPY x-dummy.conf /opt/misc
COPY entrypoint.sh /opt/misc

ENV QT_X11_NO_MITSHM=1
ENV DISPLAY=:0
WORKDIR /opt/iGibson/igibson/examples
ENTRYPOINT ["/opt/misc/entrypoint.sh"]
