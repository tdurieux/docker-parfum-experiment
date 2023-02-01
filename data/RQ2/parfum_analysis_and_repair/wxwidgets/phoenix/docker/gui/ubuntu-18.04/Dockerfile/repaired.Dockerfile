FROM wxpython4/build:ubuntu-18.04

USER root:root
RUN apt-get install --no-install-recommends -y \
        libx11-6 libxcb1 libxau6 xterm \
        tightvncserver \
        xvfb dbus-x11 x11-utils \
        xfonts-base xfonts-75dpi xfonts-100dpi \


        lubuntu-desktop && rm -rf /var/lib/apt/lists/*;
#        ubuntu-mate-desktop

RUN apt-get remove -y "*screensaver*"
RUN apt-get clean

USER ${USER}:${USER}
RUN touch ~/.Xauthority; \
        mkdir ~/.vnc; \
        echo "password" | vncpasswd -f >> ~/.vnc/passwd; \
        chmod 600 ~/.vnc/passwd; \
# And a corresponding one of these:
#        echo "exec /usr/bin/startlxde" > ~/.vnc/xstartup;
        echo "exec lxsession -e LXDE -s Lubuntu" > ~/.vnc/xstartup;
#        echo "exec mate-session" > ~/.vnc/xstartup;

RUN chmod +x ~/.vnc/xstartup;

CMD ["start-vncserver.sh"]
