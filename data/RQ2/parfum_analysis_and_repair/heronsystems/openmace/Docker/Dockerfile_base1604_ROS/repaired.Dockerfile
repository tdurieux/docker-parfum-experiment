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
RUN apt-get install --no-install-recommends -y ros-melodic-desktop-full && rm -rf /var/lib/apt/lists/*;
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
