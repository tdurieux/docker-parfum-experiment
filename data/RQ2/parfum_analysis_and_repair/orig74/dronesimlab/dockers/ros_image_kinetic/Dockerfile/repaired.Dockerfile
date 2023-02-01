#Base docker image
FROM ubuntu:xenial-20170417.1
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:george-edison55/cmake-3.x -y
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install gawk git python-pip && rm -rf /var/lib/apt/lists/*;
RUN echo "export PS1=\\\\\\\\w\\$" >> /etc/bash.bashrc
RUN apt-get -y --no-install-recommends install xterm && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN apt-get -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install gcc && rm -rf /var/lib/apt/lists/*;
#RUN apt-get -y install clang
RUN apt-get -y --no-install-recommends install unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install wget curl && rm -rf /var/lib/apt/lists/*;
#python packages
RUN apt-get -y --no-install-recommends install python-zmq && rm -rf /var/lib/apt/lists/*;

#window conrtol
RUN apt-get -y --no-install-recommends install wmctrl xdotool && rm -rf /var/lib/apt/lists/*;

#### tmux new version
RUN apt-get -y --no-install-recommends install libprotoc-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install protobuf-compiler && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install pkg-config && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install libevent1-dev libncurses5-dev && rm -rf /var/lib/apt/lists/*;
ENV LC_CTYPE=C.UTF-8
RUN cd /tmp && git clone https://github.com/tmux/tmux.git && cd tmux && git checkout tags/2.3
RUN apt-get -y --no-install-recommends install automake && rm -rf /var/lib/apt/lists/*;
RUN cd /tmp/tmux && sh ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install

#to enable copy paste in tmux mouse on https://coderwall.com/p/4b0d0a/how-to-copy-and-paste-with-tmux-on-ubuntu
RUN apt-get -y --no-install-recommends install xclip && rm -rf /var/lib/apt/lists/*;
ENV DEBIAN_FRONTEND=noninteractive
#python3
#RUN apt-get -y install curl
#RUN curl -o /miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh
#RUN /bin/bash /miniconda.sh -b -p /miniconda
#RUN PATH=/miniconda/bin conda install -y pyzmq
#RUN PATH=/miniconda/bin conda install -y numpy
RUN apt-get -y --no-install-recommends install python3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-numpy && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir pyzmq

######## ros kinetic ######
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116


RUN apt-get -y update
RUN apt-get -y --no-install-recommends --allow-unauthenticated install ros-kinetic-desktop-full && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends --allow-unauthenticated install python-wstool python-rosinstall-generator python-catkin-tools && rm -rf /var/lib/apt/lists/*;
#RUN bash -c "curl -ssL http://get.gazebosim.org | sh"
#RUN apt-get -y install ros-kinetic-desktop-full
#RUN apt-get -y install ros-kinetic-roslaunch
RUN apt-get -y --no-install-recommends install gazebo7 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libgazebo7-dev && rm -rf /var/lib/apt/lists/*;
#RUN apt-get -y install ros-kinetic-control-toolbox
#RUN apt-get -y install openssl libssl-dev
RUN apt-get -y --no-install-recommends --allow-unauthenticated install ros-kinetic-mavros ros-kinetic-mavros-extras && rm -rf /var/lib/apt/lists/*;
RUN /opt/ros/kinetic/lib/mavros/install_geographiclib_datasets.sh
#RUN apt-get -y install ros-kinetic-image-view2

#additional ros libs
RUN apt-get -y --no-install-recommends install ros-kinetic-image-pipeline && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libglew-dev && rm -rf /var/lib/apt/lists/*; #nedded by Pangolin viewer
# git checkout tags/v0.5
# .... build
RUN cd /tmp && git clone https://github.com/stevenlovegrove/Pangolin.git
RUN cd /tmp/Pangolin && git checkout tags/v0.5 && mkdir build && cd build && cmake .. && make


############################## install opencv3 and numpy for python3
RUN apt-get install --no-install-recommends -y libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libgtk2.0-dev libatlas-base-dev gfortran && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/Itseez/opencv.git
RUN cd /opencv && git checkout 3.2.0
RUN git clone https://github.com/Itseez/opencv_contrib.git
RUN cd /opencv_contrib && git checkout 3.2.0
RUN cd /opencv && mkdir build
RUN cd /opencv/build && cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local \
  -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules -D WITH_IPP=OFF -D PYTHON3_PACKAGES_PATH=/usr/local/lib/python3.5/dist-packages .. && make -j6
RUN cd /opencv/build && make install
RUN apt-get -y update

###### ORB_SLAM2
#RUN cd /tmp && git clone https://github.com/raulmur/ORB_SLAM2.git
#RUN apt-get install -y libopencv-dev
#RUN cd /tmp/ORB_SLAM2 && chmod +x build.sh
#RUN cd /tmp/ORB_SLAM2 && chmod +x build_ros.sh
#RUN cd /tmp/ORB_SLAM2 && ./build.sh
#RUN chmod 777 /tmp/ORB_SLAM2/build

RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libprotobuf-dev && rm -rf /var/lib/apt/lists/*;

###python3 ros support
#RUN PATH=/miniconda/bin:$PATH pip install --upgrade pip
RUN pip3 install --no-cache-dir pyyaml rospkg catkin_pkg


#RUN sudo -H pip install jinja2
RUN sudo apt-get install --no-install-recommends -y python-jinja2 && rm -rf /var/lib/apt/lists/*;
######## nvidia part ######
ARG GDRIVER
#COPY install_graphic_driver.sh /install_graphic_driver.sh
#RUN chmod +x /install_graphic_driver.sh
#RUN GDRIVER=$GDRIVER /install_graphic_driver.sh

###added more ros libs
#RUN apt-get -y update
#RUN apt-get install -y  --allow-unauthenticated python-rosinstall

### add python dynamics
#RUN apt-get install -y  python-testresources
#RUN apt-get install -y python-scipy
#RUN pip2 install scipy
RUN curl -f -o run.sh https://raw.githubusercontent.com/PX4/Devguide/v1.9.0/build_scripts/ubuntu_sim.sh && chmod +x ./run.sh && ./run.sh
#user setings

RUN pip2 install --no-cache-dir pydy


ARG UID
RUN useradd -u $UID docker
RUN echo "docker:docker" | chpasswd
RUN echo "docker ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
