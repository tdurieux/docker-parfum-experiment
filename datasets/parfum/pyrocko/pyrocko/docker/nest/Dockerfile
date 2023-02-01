FROM debian:stable

RUN apt-get update -y
RUN apt-get upgrade -y

# env requirements
RUN apt-get install -y python3-pip
RUN pip3 install twine
RUN apt-get install -y wget

# linter requirements
RUN pip3 install flake8

# build requirements
RUN apt-get install -y make git
RUN apt-get install -y python3-dev python3-setuptools python3-numpy-dev

# testing requirements
RUN apt-get install -y xvfb libgles2-mesa
RUN apt-get install -y python3-coverage python3-nose

# base runtime requirements
RUN apt-get install -y \
        python3-numpy python3-scipy python3-matplotlib \
        python3-requests python3-future \
        python3-yaml python3-progressbar

# gui runtime requirements
RUN apt-get install -y \
        python3-pyqt5 python3-pyqt5.qtopengl python3-pyqt5.qtsvg \
        python3-pyqt5.qtwebengine python3-pyqt5.qtwebkit

# optional runtime requirements
RUN apt-get install -y \
        python3-jinja2 python3-pybtex

# additional runtime requirements for gmt
RUN apt-get install -y \
        gmt gmt-gshhg poppler-utils imagemagick

# additional runtime requirements for fomosto backends
RUN apt-get install -y autoconf gfortran
WORKDIR /src
RUN git clone https://git.pyrocko.org/pyrocko/fomosto-qseis.git \
    && cd fomosto-qseis && autoreconf -i && ./configure && make && make install
WORKDIR /src
RUN git clone https://git.pyrocko.org/pyrocko/fomosto-psgrn-pscmp.git \
    && cd fomosto-psgrn-pscmp && autoreconf -i && ./configure && make && make install
WORKDIR /src
RUN git clone https://git.pyrocko.org/pyrocko/fomosto-qseis2d.git \
    && cd fomosto-qseis2d && autoreconf -i && ./configure && make && make install
WORKDIR /src
RUN git clone https://git.pyrocko.org/pyrocko/fomosto-qssp.git \
    && cd fomosto-qssp && autoreconf -i && ./configure && make && make install
WORKDIR /src
RUN git clone https://git.pyrocko.org/pyrocko/fomosto-qssp2017.git \
    && cd fomosto-qssp2017 && autoreconf -i && ./configure && make && make install

