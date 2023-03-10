FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
ENV DISPLAY :1

RUN apt-get update && \
    apt-get -y --no-install-recommends install xserver-xorg-video-dummy x11-apps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


VOLUME /tmp/.X11-unix

ADD http://xpra.org/xorg.conf /etc/X11/xorg.conf

CMD ["/usr/bin/Xorg", "-noreset", "+extension", "GLX", "+extension", "RANDR", "+extension", "RENDER", "-logfile", "./xdummy.log", "-config", "/etc/X11/xorg.conf", ":1"]

# docker build -t dummyx11 -f Dockerfile.dummyX11 .
# docker volume create --name x11tmp
# docker create --name dummyx11 -v x11tmp:/tmp/.X11-unix dummyx11
# docker start dummyx11

