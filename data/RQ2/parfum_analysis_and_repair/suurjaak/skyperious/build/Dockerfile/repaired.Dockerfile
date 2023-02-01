# Run Skyperious in a container. Building the image:
#
#     docker build . -t skyperious
#
# and running afterwards:
#
#     xhost +
#     docker run -it --rm --net=host --mount src=/,target=/mnt/host,type=bind -e DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix/ skyperious
#
# Add 'sudo' before docker commands if current user does not have rights for Docker.
#
# Add '--mount src="path to host directory",target=/etc/skyperious' after 'docker run'
# to retain Skyperious configuration in a host directory between runs.
#
# Host filesystem is made available under /mnt/host.

FROM ubuntu:20.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    libgtk-3-0 \
    libsdl2-2.0 \
    libwebkit2gtk-4.0-37 \
    python3 \
    python3-pip && rm -rf /var/lib/apt/lists/*;

ENV LC_ALL   en_US.UTF-8
ENV LANG     en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN pip install --no-cache-dir wxPython==4.1.1 \
    --find-links https://extras.wxpython.org/wxPython4/extras/linux/gtk3/ubuntu-20.04

RUN pip install --no-cache-dir skyperious

RUN printf '\nConfigFile = "/etc/skyperious/skyperious.ini"\n' \
    >> /usr/local/lib/python3.8/dist-packages/skyperious/conf.py

VOLUME /etc/skyperious

CMD /usr/local/bin/skyperious
