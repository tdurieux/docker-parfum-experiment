# Docker file for RoboCup@HomeEducation
# ROS Kinetic, navigation, perception & additional packages
# Version 1.0.3 - 17/10/2020
# 

FROM rchomeedu-1604-kinetic:1.0.2

USER robot

# Trick to disable cache from here
ADD http://worldtimeapi.org/api/ip /tmp/time.tmp 

RUN cd $HOME/src/stage_environments && git pull && \
    cd $HOME/src/gradient_based_navigation && git pull && \
    cd $HOME/src/modim && git pull && \
    cd $HOME/src/marrtino_apps && git pull && \
    cd $HOME/src/rc-home-edu-learn-ros && git pull

# Compile ROS packages