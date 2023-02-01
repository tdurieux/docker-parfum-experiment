FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt install --no-install-recommends -y \
      xvfb \
      ffmpeg \
      irssi \
      tmux \
      libfuse2 \
      xdotool \
      sudo \
      xterm \
      fuse \
      x11-apps && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y dbus-x11 procps psmisc x11-utils x11-xserver-utils xosd-bin && rm -rf /var/lib/apt/lists/*;

# Xfce
RUN apt-get install -y --no-install-recommends xfce4 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gtk3-engines-xfce xfce4-notifyd && rm -rf /var/lib/apt/lists/*;

# additional Xfce goodies
RUN apt-get install --no-install-recommends -y mousepad xfce4-taskmanager xfce4-terminal && rm -rf /var/lib/apt/lists/*;

# includes GTK3 broadway support for HTML5 web applications
RUN apt-get install -y --no-install-recommends libgtk-3-bin && rm -rf /var/lib/apt/lists/*;

# additional Xfce panel plugins
RUN apt-get install -y --no-install-recommends xfce4-battery-plugin \
    xfce4-clipman-plugin xfce4-cpugraph-plugin xfce4-datetime-plugin \
    xfce4-netload-plugin xfce4-notes-plugin xfce4-places-plugin \
    xfce4-sensors-plugin xfce4-systemload-plugin \
    xfce4-whiskermenu-plugin xfce4-indicator-plugin \
    xfce4-cpufreq-plugin xfce4-diskperf-plugin xfce4-fsguard-plugin \
    xfce4-genmon-plugin xfce4-smartbookmark-plugin xfce4-timer-plugin \
    xfce4-verve-plugin xfce4-weather-plugin && rm -rf /var/lib/apt/lists/*;

ADD irssi_config /home/user/.irssi/config

ENV DISPLAY ":99"
RUN echo '#! /bin/sh\n\
sed -i"" "s,%TWITCH_OAUTH%%,${TWITCH_OAUTH},g" /home/user/.irssi/config\n\
Xvfb ${DISPLAY} -pixdepths 24 32 -listen tcp -ac -screen 0 1920x1080x24\n\
[ -n "$HOME" ] && [ ! -e "$HOME/.config" ] && cp -R /etc/skel/. $HOME/ \n\
exec $*\n\
' > /usr/local/bin/start

#xterm -g 600x50+0+350 -T chat -e sh -c 'tmux attach -t irssi'
RUN useradd -ms /bin/bash -u 1000 user && \
    echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/default

ADD /xfce-config.tgz /home/user/.config/xfce4
ENV IRSSI_CONFIG "/home/user/.config/Unknown Organization/silverkey.conf"
COPY ./silverkey.conf $IRSSI_CONFIG

RUN chmod +x /usr/local/bin/start
