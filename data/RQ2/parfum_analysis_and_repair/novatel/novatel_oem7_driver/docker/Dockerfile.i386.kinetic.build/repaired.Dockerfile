from osrf/ubuntu_i386:xenial


SHELL ["/bin/bash", "-c"]

RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get update && apt-get install --no-install-recommends -y ros-kinetic-ros-base ros-kinetic-tf2-geometry-msgs ros-kinetic-gps-common ros-kinetic-nmea-msgs ros-kinetic-nav-msgs ros-kinetic-rosdoc-lite dh-make python-bloom vim sudo && rm -rf /var/lib/apt/lists/*;

ENV ROS_DISTRO=kinetic


#----------------------------------
RUN groupadd -g 1000 build 
RUN useradd -u 1000 -g 1000 -G sudo,build,dialout -ms /bin/bash build
RUN echo "build:build" | chpasswd
USER build
#----------------------------------


# If no command is provided when the container is started, this will be run, giving you a shell inside the container as the 'build' user.
CMD "/bin/bash"
