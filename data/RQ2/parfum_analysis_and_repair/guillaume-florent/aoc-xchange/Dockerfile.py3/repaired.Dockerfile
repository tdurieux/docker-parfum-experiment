FROM guillaumeflorent/miniconda-pythonocc:3-0.18.3

MAINTAINER Guillaume Florent <florentsailing@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*

RUN conda install -y numpy pytest
RUN conda install -c gflorent corelib aocutils

RUN apt-get update && apt-get install --no-install-recommends -y libgtk2.0-0 && rm -rf /var/lib/apt/lists/*
RUN conda install -y -c anaconda wxpython

RUN conda install -y pyqt
RUN apt-get update && apt-get install --no-install-recommends -y libgl1-mesa-dev libx11-xcb1 && rm -rf /var/lib/apt/lists/*

# aocxchange
WORKDIR /opt
# ADD https://api.github.com/repos/guillaume-florent/aoc-xchange/git/refs/heads/master version.json
RUN git clone --depth=1 https://github.com/guillaume-florent/aoc-xchange
WORKDIR /opt/aoc-xchange
RUN python setup.py install

# setup.py should deal with the installation of command line utilities
