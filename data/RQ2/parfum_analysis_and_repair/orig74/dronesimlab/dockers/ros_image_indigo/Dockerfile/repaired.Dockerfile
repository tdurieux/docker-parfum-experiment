#Base docker image
FROM ubuntu:14.04
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:george-edison55/cmake-3.x -y
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install python-scipy gawk git python-pip && rm -rf /var/lib/apt/lists/*;
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

#python3
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -o /miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh
RUN /bin/bash /miniconda.sh -b -p /miniconda
RUN PATH=/miniconda/bin conda install -y pyzmq
RUN PATH=/miniconda/bin conda install -y numpy


######## ros indigo ######
RUN echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net --recv-key 0xB01FA116
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install ros-indigo-desktop && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python-wstool python-rosinstall-generator python-catkin-tools && rm -rf /var/lib/apt/lists/*;
#RUN bash -c "curl -ssL http://get.gazebosim.org | sh"
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list
RUN wget https://packages.osrfoundation.org/gazebo.key -O - | apt-key add -
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install gazebo7 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install ros-indigo-gazebo7-ros-pkgs && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libgazebo7-dev && rm -rf /var/lib/apt/lists/*;






RUN apt-get -y --no-install-recommends install ros-indigo-roslaunch && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install ros-indigo-control-toolbox && rm -rf /var/lib/apt/lists/*;
#RUN apt-get -y install openssl libssl-dev
RUN apt-get -y --no-install-recommends install ros-indigo-mavros ros-indigo-mavros-extras && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install ros-indigo-image-view2 && rm -rf /var/lib/apt/lists/*;


#additional ros libs
RUN apt-get -y --no-install-recommends install ros-indigo-image-pipeline && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libglew-dev && rm -rf /var/lib/apt/lists/*; #nedded by Pangolin viewer
# git checkout tags/v0.5
# .... build
RUN cd /tmp && git clone https://github.com/stevenlovegrove/Pangolin.git
RUN cd /tmp/Pangolin && git checkout tags/v0.5 && mkdir build && cd build && cmake .. && make
###### ORB_SLAM2
RUN cd /tmp && git clone https://github.com/raulmur/ORB_SLAM2.git
RUN cd /tmp/ORB_SLAM2 && chmod +x build.sh
RUN cd /tmp/ORB_SLAM2 && chmod +x build_ros.sh
RUN cd /tmp/ORB_SLAM2 && ./build.sh
RUN chmod 777 /tmp/ORB_SLAM2/build

######## nvidia part ######
ARG GDRIVER
COPY install_graphic_driver.sh /install_graphic_driver.sh
RUN chmod +x /install_graphic_driver.sh
RUN GDRIVER=$GDRIVER /install_graphic_driver.sh



#user setings
ARG UID
RUN useradd -u $UID docker
RUN echo "docker:docker" | chpasswd
RUN echo "docker ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
