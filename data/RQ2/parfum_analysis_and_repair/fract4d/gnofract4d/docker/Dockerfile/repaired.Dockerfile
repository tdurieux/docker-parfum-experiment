FROM ubuntu:18.04

ENV TZ=Europe/Minsk
ENV DEBIAN_FRONTEND=noninteractive

# project deps
RUN \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install gir1.2-gtk-3.0 libjpeg-dev libpng-dev pkg-config python3-gi-cairo python3-pip xvfb && rm -rf /var/lib/apt/lists/*;

# bin/run_builds.sh deps
RUN \
    apt-get update && \
    apt-get -y --no-install-recommends install software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get -y --no-install-recommends install python3.6-dev python3.7-dev python3.8-dev && rm -rf /var/lib/apt/lists/*;

# Gio.AppInfo.launch_default_for_uri() deps
RUN apt-get -y --no-install-recommends install firefox gvfs && rm -rf /var/lib/apt/lists/*;

# bin/run_pylint.sh deps
RUN pip3 install --no-cache-dir pylint

# bin/run_pytest.sh deps
RUN pip3 install --no-cache-dir pytest

# bin/run_tox.sh deps
RUN apt-get -y --no-install-recommends install libcairo2-dev libgirepository1.0-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir tox

# Xvfb (in memory x11 server) setup
ENV DISPLAY :99
RUN echo "Xvfb :99 -screen 0 640x480x8 -nolisten tcp &" > /root/xvfb.sh && chmod +x /root/xvfb.sh

WORKDIR /root/gnofract

CMD py3clean /root/gnofract && /root/xvfb.sh && tail -f /dev/null
