FROM debian:stable

RUN apt-get update -y
RUN apt-get upgrade -y

# env requirements
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir twine
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# linter requirements
RUN pip3 install --no-cache-dir flake8

# build requirements
RUN apt-get install --no-install-recommends -y make git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-dev python3-setuptools python3-numpy-dev && rm -rf /var/lib/apt/lists/*;

# testing requirements
RUN apt-get install --no-install-recommends -y xvfb libgles2-mesa && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-coverage python3-nose && rm -rf /var/lib/apt/lists/*;

# base runtime requirements
RUN apt-get install --no-install-recommends -y \
        python3-numpy python3-scipy python3-matplotlib \
        python3-requests python3-future \
        python3-yaml python3-progressbar && rm -rf /var/lib/apt/lists/*;

# gui runtime requirements
RUN apt-get install --no-install-recommends -y \
        python3-pyqt5 python3-pyqt5.qtopengl python3-pyqt5.qtsvg \
        python3-pyqt5.qtwebengine python3-pyqt5.qtwebkit && rm -rf /var/lib/apt/lists/*;

# optional runtime requirements
RUN apt-get install --no-install-recommends -y \
        python3-jinja2 python3-pybtex && rm -rf /var/lib/apt/lists/*;

# additional runtime requirements for gmt
RUN apt-get install --no-install-recommends -y \
        gmt gmt-gshhg poppler-utils imagemagick && rm -rf /var/lib/apt/lists/*;

# additional runtime requirements for fomosto backends
RUN apt-get install --no-install-recommends -y autoconf gfortran && rm -rf /var/lib/apt/lists/*;
WORKDIR /src
RUN git clone https://git.pyrocko.org/pyrocko/fomosto-qseis.git \
    && cd fomosto-qseis && autoreconf -i && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install
WORKDIR /src
RUN git clone https://git.pyrocko.org/pyrocko/fomosto-psgrn-pscmp.git \
    && cd fomosto-psgrn-pscmp && autoreconf -i && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install
WORKDIR /src
RUN git clone https://git.pyrocko.org/pyrocko/fomosto-qseis2d.git \
    && cd fomosto-qseis2d && autoreconf -i && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install
WORKDIR /src
RUN git clone https://git.pyrocko.org/pyrocko/fomosto-qssp.git \
    && cd fomosto-qssp && autoreconf -i && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install
WORKDIR /src
RUN git clone https://git.pyrocko.org/pyrocko/fomosto-qssp2017.git \
    && cd fomosto-qssp2017 && autoreconf -i && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

