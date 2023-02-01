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
RUN apt-get install -y --no-install-recommends fvwm && rm -rf /var/lib/apt/lists/*;

ENV DISPLAY "xvfb:99"
RUN echo '#! /bin/sh\n\
sudo -i -u user fvwm -replace\n\
' > /usr/local/bin/start
RUN chmod +x /usr/local/bin/start

#xterm -g 600x50+0+350 -T chat -e sh -c 'tmux attach -t irssi'
RUN useradd -ms /bin/bash -u 1000 user && \
    echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/default

ENV SILVERKEY_CONFIG "/home/user/.config/Unknown Organization/silverkey.conf"
COPY ./silverkey.conf $SILVERKEY_CONFIG

RUN chown -R user:user /home/user

ENTRYPOINT [ "/usr/local/bin/start" ]

