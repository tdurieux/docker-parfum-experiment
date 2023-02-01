FROM debian:latest
MAINTAINER Tristan Salles

# install things
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
        bash-completion \
        build-essential \
        git \
        python3-minimal \
        python3-dev \
        python3-pip \
        libxml2-dev \
        xorg-dev \
        ssh \
        curl \
        libfreetype6-dev \
        libpng-dev \
        libxft-dev \
        xvfb \
        python3-tk \
        mesa-utils \
        rsync \
        vim \
        less \
        xauth \
        swig \
        gdb-minimal \
        python3-dbg \
        cmake \
        python3-setuptools \
        wget \
        gfortran  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV LANG=C.UTF-8
# Install setuptools and wheel first, needed by plotly
RUN pip3 install --no-cache-dir -U setuptools && \
    pip3 install --no-cache-dir -U wheel && \
    pip3 install --no-cache-dir packaging \
        appdirs \
        numpy \
        jupyter \
        plotly \
        matplotlib \
        pillow \
        scipy

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# install extras in a new layer
RUN python3 -m pip install --no-cache-dir \
        ipython \
        jupyter

# Install Tini.. this is required because CMD (below) doesn't play nice with notebooks for some reason: https://github.com/ipython/ipython/issues/7062, https://github.com/jupyter/notebook/issues/334
RUN curl -f -L https://github.com/krallin/tini/releases/download/v0.10.0/tini > tini && \
    echo "1361527f39190a7338a0b434bd8c88ff7233ce7b9a4876f3315c22fce7eca1b0  *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

# expose notebook port
EXPOSE 8888

# create a volume
RUN mkdir /live && \
    mkdir /live/lib

VOLUME /live/share
WORKDIR /live


EXPOSE 9999
# script for xvfb-run.  all docker commands will effectively run under this via the entrypoint
RUN printf "#\041/bin/sh \n rm -f /tmp/.X99-lock && xvfb-run -s '-screen 0 1600x1200x16' \$@" >> /usr/local/bin/xvfbrun.sh && \
chmod +x /usr/local/bin/xvfbrun.sh

# Add Tini
EXPOSE 8888
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/local/bin/tini
RUN chmod +x /usr/local/bin/tini
ENTRYPOINT ["/usr/local/bin/tini", "--"]

# note we use xvfb which to mimic the X display
ENTRYPOINT ["/usr/local/bin/xvfbrun.sh"]

ADD run-jupyter.sh /usr/local/bin/run-jupyter.sh
RUN chmod +x /usr/local/bin/run-jupyter.sh
CMD /usr/local/bin/run-jupyter.sh
