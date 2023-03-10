FROM ubuntu:focal
LABEL maintainer="Daniel Webster <dsw@cloudbusting.io>"

ENV VERSION=2.6.1

RUN apt update -y && DEBIAN_FRONTEND=noninteractive apt -y --no-install-recommends install \
    tzdata keyboard-configuration git coreutils curl xbase-clients \
    xdg-utils firefox libosmesa6 mesa-utils libgl1-mesa-glx openmpi-bin \
    libopenmpi-dev libnexus1 libnexus-dev emacs vim fonts-liberation \
    python3-pip python3-dev jupyter && \
    curl -f https://packages.mccode.org/debian/mccode.list > /etc/apt/sources.list.d/mccode.list && \
    apt update -y && apt install -y --no-install-recommends mcstas-suite-python mcstas-suite-perl && \
    curl -f https://raw.githubusercontent.com/McStasMcXtrace/McCode/master/tools/Python/mcgui/mcgui.py >\
    /usr/share/mcstas/2.6.1/tools/Python/mcgui/mcgui.py && \
    curl -f https://raw.githubusercontent.com/McStasMcXtrace/McCode/master/tools/Python/mccodelib/mccode_config.py >\
    /usr/share/mcstas/2.6.1/tools/Python/mccodelib/mccode_config.py && \
    python3 -m pip install McStasScript --upgrade && \
    curl -f https://raw.githubusercontent.com/McStasMcXtrace/McCode/master/Docker/mcstas/mcstasscript/mcstasscript-setup.py >\
    /tmp/mcstasscript-setup.py && \
    python3 /tmp/mcstasscript-setup.py && \
    python3 -m pip install jupyter && \
    # The following works around https://github.com/sphinx-doc/sphinx/issues/8198
    python3 -m pip install pygments==2.6.1 && \
    update-alternatives --install /bin/sh sh /bin/bash 200 && \
    update-alternatives --install /bin/sh sh /bin/dash 100 && \
    rm -rf /var/lib/apt/lists/*

ENV HOME /home/docker
WORKDIR /home/docker

RUN groupadd docker && useradd -m -g docker docker && \
    mkdir /home/mcstasscript && \
    cd /home/mcstasscript && \
    curl -f -O https://raw.githubusercontent.com/McStasMcXtrace/McCode/master/Docker/mcstas/mcstasscript/McStasScript_demo.ipynb && \
    chown -R docker:docker /home/mcstasscript

