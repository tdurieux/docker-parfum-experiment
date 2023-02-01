# x11docker/deepin
# 
# Run deepin desktop in docker. 
# Use x11docker to run image. 
# Get x11docker from github: 
#   https://github.com/mviereck/x11docker 
#
# Run desktop with:
#   x11docker --desktop --systemd x11docker/deepin
# (Alternativly start with:)
#   x11docker --desktop --dbus-system --pulseaudio x11docker/deepin
#
# Run single application:
#   x11docker x11docker/deepin deepin-terminal
#
# Options:

# Persistent home folder stored on host with   --home
# Shared host folder with                      --sharedir DIR
# Hardware acceleration with option            --gpu
# Clipboard sharing with option                --clipboard
# Change desired language locale setting with  --lang $LANG
# Sound support with option                    --pulseaudio
#
# See x11docker --help for further options.

FROM bestwu/deepin:panda
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="zh_CN.UTF-8" \
    LANGUAGE="zh_CN.UTF-8" \
    LC_ALL="zh_CN.UTF-8" \
    TIMEZONE="Asia/Shanghai" \
    DEBIAN_FRONTEND="noninteractive"

#RUN echo "deb http://packages.deepin.com/deepin/ panda main non-free contrib" > /etc/apt/sources.list
RUN echo "deb [by-hash=force] https://mirrors.aliyun.com/deepin panda main contrib non-free" > /etc/apt/sources.list
#RUN echo "deb http://mirrors.kernel.org/deepin/  panda main non-free contrib" > /etc/apt/sources.list
#RUN echo "deb http://ftp.fau.de/deepin/          panda main non-free contrib" > /etc/apt/sources.list

RUN rm -rf /var/lib/apt/lists/* && apt-get -y clean && apt-get -y update && \
    apt-get dist-upgrade -y && apt-get -y autoremove 
RUN apt-get install -y dbus-x11 procps psmisc

# OpenGL / MESA
RUN apt-get install -y mesa-utils mesa-utils-extra libxv1 kmod xz-utils

# language locales. Change LANG to your desired default locale
RUN apt-get install -y locales-all 

# deepin desktop
RUN apt-get install -y --no-install-recommends dde

# missing dependencies, dconf
RUN apt-get install -y --no-install-recommends at-spi2-core dconf-cli dconf-editor \
    gnome-themes-standard gtk2-engines-murrine gtk2-engines-pixbuf

# additional applications
RUN apt-get install -y deepin-calculator deepin-image-viewer deepin-screenshot \
    deepin-system-monitor deepin-terminal deepin-movie deepin-music \
    gedit sudo lspci synaptic oneko google-chrome-stable firefox-zh \
    deepin-fpapp-com.deepin.imageviewer deepin-fpapp-com.deepin.music \
    deepin-fpapp-com.deepin.screenshot deepin-movie wps-office \
    foxitreader netease-cloud-music sogoupinyin fonts-adobe-source-han-serif-cn \
    fonts-droid fonts-hanazono fonts-lohit-deva fonts-nanum

# chinese fonts
RUN apt-get install -y fonts-arphic-uming

ENV PATH /usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/games:/usr/games

# Mask units failing in container
RUN systemctl mask \
    bluetooth \
    iptables \
    systemd-hostnamed \
    systemd-tmpfiles-setup

# Mask units useless in container
RUN systemctl mask \
    lastore-daemon lastore-update-metadata-info \
    NetworkManager \
    plymouth-start plymouth-read-write plymouth-quit plymouth-quit-wait

# Remove dbus services failing or useless in container. (Bluetooth/bluez is most annoying)
RUN cd /usr/share/dbus-1/services && rm \
    com.deepin.daemon.Audio.service \
    com.deepin.daemon.Bluetooth.service \
    com.deepin.daemon.InputDevices.service \
    com.deepin.daemon.Power.service \
    com.deepin.dde.welcome.service
RUN cd /usr/share/dbus-1/system-services && rm \
    com.deepin.lastore.service
RUN ln -s /etc/sv/gdm /var/service
# config file to use deepin-metacity without 3d effects ,not deepin-wm
RUN echo -e '{\n\
    "allow_switch": true,\n\
    "last_wm": "deepin-metacity"\n\
}\n\
' >/wm3d.json

# create startscript 
RUN echo -e '#! /bin/sh\n\
[ -n "$HOME" ] && [ ! -e "$HOME/.config" ] && cp -R /etc/skel/. $HOME/ \n\
[ -e /dev/dri/card0 ] && { \n\
  mkdir -p $HOME/.config/deepin/deepin-wm-switcher \n\
  cp -n /wm3d.json $HOME/.config/deepin/deepin-wm-switcher/config.json \n\
} \n\
dconf write /com/deepin/dde/daemon/network false \n\
dconf write /com/deepin/dde/daemon/bluetooth false \n\
dconf write /com/deepin/dde/watchdog/dde-polkit-agent false \n\
dconf write /com/deepin/dde/daemon/power false \n\
exec $* \n\
' > /usr/bin/start 
RUN chmod +x /usr/bin/start

ENTRYPOINT ["/usr/bin/start"]
CMD ["startdde"]

ENV DEBIAN_FRONTEND newt
