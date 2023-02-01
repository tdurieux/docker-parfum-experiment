# Base docker image
FROM ubuntu:18.04
RUN pwd
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y --no-install-recommends install gawk git && rm -rf /var/lib/apt/lists/*;
RUN echo "export PS1=\\\\\\\\w\\$" >> /etc/bash.bashrc
RUN apt-get -y --no-install-recommends install xterm && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install wget tmux && rm -rf /var/lib/apt/lists/*;

######## python3 ##########

RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt-get -y update
#RUN apt-get -y install gcc-8
#RUN apt-cache search gcc-
RUN apt-get -y upgrade libstdc++6

######## nvidia part ######
ARG GDRIVER
COPY install_graphic_driver.sh /install_graphic_driver.sh
RUN chmod +x /install_graphic_driver.sh
RUN GDRIVER=$GDRIVER /install_graphic_driver.sh

######## user settings ######
ENV QT_X11_NO_MITSHM 1
ARG UID
RUN apt-get install -y --no-install-recommends sudo && rm -rf /var/lib/apt/lists/*;
RUN useradd -u $UID docker
RUN echo "docker:docker" | chpasswd
RUN echo "root:root" | chpasswd
RUN echo "docker ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers


#### for ardusub ######
RUN apt-get -y --no-install-recommends install python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir mavproxy

###  gstreamer ######
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libgtk2.0-dev pkg-config && rm -rf /var/lib/apt/lists/*;

### this fixes missing sdl-config dependencies during pygame install
RUN apt-get install --no-install-recommends -y libsdl1.2-dev libsdl-image1.2-dev libsdl-ttf2.0-dev libsdl-mixer1.2-dev libportmidi-dev && rm -rf /var/lib/apt/lists/*;

#RUN curl -o /miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh
#RUN curl -o /miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-4.3.30-Linux-x86_64.sh
#RUN curl -o  /miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-4.5.4-Linux-x86_64.sh

#RUN /bin/bash /miniconda.sh -b -p /miniconda
#RUN PATH=/miniconda/bin conda install -y python=3.7
#RUN PATH=/miniconda/bin conda install -y pyzmq
#RUN PATH=/miniconda/bin conda install -c menpo opencv=3.2.0
#RUN PATH=/miniconda/bin:$PATH pip install --upgrade pip
#RUN PATH=/miniconda/bin:$PATH pip install pymavlink
#RUN PATH=/miniconda/bin:$PATH pip install cffi
#RUN PATH=/miniconda/bin:$PATH pip install opencv-python
#RUN PATH=/miniconda/bin:$PATH pip install opencv-contrib-python
#RUN PATH=/miniconda/bin:$PATH pip install dill
#RUN PATH=/miniconda/bin:$PATH pip install pygame
#RUN PATH=/miniconda/bin:$PATH pip install scipy

RUN apt-get -y --no-install-recommends install python3.7-dev python3-pip && rm -rf /var/lib/apt/lists/*;
#RUN rm /usr/bin/python && ln -s /usr/bin/python3.7 /usr/bin/python
RUN python3.7 -m pip install pip
RUN python3.7 -m pip install pyzmq cffi opencv-python opencv-contrib-python dill pygame scipy
RUN python3.7 -m pip install pymavlink
#RUN pip install -y pyzmq opencv-python pymavlink cffi opencv-contrib-python dill pygame scipy
#for compatability:
RUN mkdir -p /miniconda/bin && ln -s /usr/bin/python3.7 /miniconda/bin/python
RUN rm -rf /usr/bin/python3 && ln -s /usr/bin/python3.7 /usr/bin/python3
