# Docker file for RoboCup@HomeEducation
# ROS Melodic, navigation, perception & additional packages
# Update

FROM ros-melodic-rchomeedu:0.1

###### User robot ######

USER robot

# Update packages

RUN cd $HOME/src/rc-home-edu-learn-ros && git pull && \
    cd $HOME/src/marrtino_apps && git pull && \
    cd $HOME/src/stage_environments && git pull && \
    cd $HOME/src/gradient_based_navigation && git pull

# Compile ROS packages

RUN /bin/bash -ci "cd $HOME/ros/catkin_ws; catkin_make"


# Set working dir and container command