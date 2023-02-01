# Base docker image
FROM ubuntu:14.04
RUN pwd
RUN apt-get -y update
#RUN apt-get -y install build-essential
RUN apt-get -y --no-install-recommends install python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install ccache gawk git python-pexpect python-lxml && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir future pymavlink MAVProxy
RUN echo "export PS1=\\\\\\\\w\\$" >> /etc/bash.bashrc
RUN mkdir -p /.tilecache/SRTM
RUN chmod -R 777 /.tilecache

#install tmux new version
RUN apt-get -y --no-install-recommends install libevent1-dev libncurses5-dev && rm -rf /var/lib/apt/lists/*;
ENV LC_CTYPE=C.UTF-8
RUN cd /tmp && git clone https://github.com/tmux/tmux.git && cd tmux && git checkout tags/2.3
RUN apt-get -y --no-install-recommends install automake && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install pkg-config && rm -rf /var/lib/apt/lists/*;
RUN cd /tmp/tmux && sh ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install

#python3
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -o /miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh
RUN /bin/bash /miniconda.sh -b -p /miniconda
RUN PATH=/miniconda/bin conda install -y pyzmq
RUN PATH=/miniconda/bin conda install -c menpo opencv3=3.2.0
RUN PATH=/miniconda/bin:$PATH pip --no-cache-dir install pymavlink
RUN apt-get -y --no-install-recommends install libgtk2.0-dev && rm -rf /var/lib/apt/lists/*;

#https://coderwall.com/p/4b0d0a/how-to-copy-and-paste-with-tmux-on-ubuntu
RUN apt-get -y --no-install-recommends install xclip && rm -rf /var/lib/apt/lists/*;

### normal user settings
ARG UID
RUN useradd -u $UID docker
RUN echo "docker:docker" | chpasswd
RUN echo "root:root" | chpasswd
RUN echo "docker ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

### add this line to consume the GDRIVER since the build scripts gives the GDRIVER as an argument even
### if it is not needed
ARG GDRIVER
RUN GDRIVER=$GDRIVER

### fix anaconda import cv2 issue
### "ibpangocairo-1.0.so.0: undefined symbol: cairo_ft_font_options_substitute"
RUN /miniconda/bin/conda update -y cairo
