# README
#####
# Build & Rebuild with the following command
# sudo docker build -t ubuntu1604:mace .
#####
###
# Now is a good time to learn how to use screen, otherwise the following commands will help you attach/detach and open new terminals
###
### Run and attach with a terminal with:
# sudo docker run -it ubuntu1604:mace
###
# To detach use: Ctrl+p + Ctrl+q
###
# To reattach: sudo docker attach [CONTAINER-ID] (you may have to press enter again to get the command line back)
###
# To start a new bash shell (so you don't interrupt something else you were running)
#     sudo docker exec -ti [CONTAINER-ID] bash
# With a new bash shell run "exit" instead of Ctrl+p + Ctrl+q
#####

## DON'T CHANGE THIS STUFF
#Download base image ubuntu 16.04
FROM ubuntu:16.04

# Update Ubuntu Software repository
RUN apt-get update
RUN apt-get update
## START CHANGING STUFF

# Install tools here, (recommended to use multiple lines so they don't have to all reinstall if you change one)
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nano && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y tmux && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN apt-get install --no-install-recommends -y qt5-default && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libqt5serialport5-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-system-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade virtualenv

# Install ROS
# May not need this first apt-get update...
RUN apt-get update
RUN apt-get install --no-install-recommends -y lsb-release && rm -rf /var/lib/apt/lists/*;
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get update
RUN apt-get install --no-install-recommends -y ros-kinetic-desktop-full && rm -rf /var/lib/apt/lists/*;
RUN rosdep init
RUN rosdep update
RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"
RUN apt-get install --no-install-recommends -y python-rosinstall && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-rosinstall-generator && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-wstool && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ros-kinetic-octomap* && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ros-kinetic-tf* && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-rospkg && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir rospkg

# Install things in order of least likely to change
### MACE deps
RUN git clone https://github.com/heronsystems/OpenMACE
WORKDIR /OpenMACE

# TESTING
RUN git checkout MACEDigiWrapper_Migration
# END TESTING

RUN git submodule init
RUN git submodule update
## FLANN
WORKDIR /OpenMACE/tools/flann
RUN mkdir build
WORKDIR /OpenMACE/tools/flann/build
RUN CXXFLAGS=-std=c++11 cmake ..
RUN make -j1
RUN make install

## Octomap
WORKDIR /OpenMACE/tools/octomap
RUN mkdir build
WORKDIR /OpenMACE/tools/octomap/build
RUN cmake ..
RUN make
RUN make install

## Libccd
WORKDIR /OpenMACE/tools/libccd
RUN mkdir build
WORKDIR /OpenMACE/tools/libccd/build
RUN cmake -G "Unix Makefiles" ..
RUN make
RUN make install

## FCL
# RUN cd ./tools/fcl && mkdir build && cd ./build && cmake .. -DEIGEN3_INCLUDE_DIR=/MACE/Eigen/include/eigen3/ && make && make install

### Actual MACE
## Env vars
ENV MACE_ROOT /OpenMACE
## LD conf
RUN echo "/OpenMACE/lib" > /etc/ld.so.conf.d/OpenMACE.conf

# Build OpenMACE catkin directory:
WORKDIR /OpenMACE/catkin_sim_environment
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash && catkin_make; exit 0'
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash && catkin_make; exit 0'
RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash && catkin_make'
RUN echo "source /OpenMACE/catkin_sim_environment/devel/setup.bash" >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

## Build mace
WORKDIR /OpenMACE

# TESTING
RUN git fetch
RUN git pull origin MACEDigiWrapper_Migration
# END TESTING

RUN mkdir build bin lib include
WORKDIR /OpenMACE/build

RUN qmake ../src/src.pro
RUN make
RUN make install
RUN ldconfig


## TMUX Configuration
COPY tmux/.tmux.conf /root/
COPY tmux/.tmux.conf.local /root/


WORKDIR /OpenMACE