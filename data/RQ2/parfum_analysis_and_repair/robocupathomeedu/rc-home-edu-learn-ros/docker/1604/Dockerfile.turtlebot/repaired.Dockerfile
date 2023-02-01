# Docker file for RoboCup@HomeEducation
# ROS Kinetic, navigation, perception & additional packages
# Version 0.8-turtlebot

FROM ros-kinetic-rchomeedu:0.8

ARG DEBIAN_FRONTEND=noninteractive

###### User root ######

USER root

# install libraries and ros packages

RUN apt-get update && apt-get install --no-install-recommends -y \
        ros-kinetic-turtlebot ros-kinetic-turtlebot-apps \
        ros-kinetic-turtlebot-interactions ros-kinetic-turtlebot-simulator \
        ros-kinetic-kobuki-ftdi ros-kinetic-ar-track-alvar-msgs && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /var/lib/apt/lists/*


###### User robot ######

USER robot


# Set working dir and container command

WORKDIR /home/robot

CMD /usr/bin/tmux


