# Docker file for RoboCup@HomeEducation
# ROS Kinetic, navigation, perception & additional packages
# Version base

FROM ros:kinetic-ros-base-xenial

ARG MACHTYPE=default

ARG DEBIAN_FRONTEND=noninteractive

###### User root ######

# install libraries and ros packages

RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        tmux less sudo eom nano \
        wget iputils-ping net-tools openssh-client nginx \
        python-pip alsa-base alsa-utils pulseaudio pulseaudio-utils \
        sox mplayer libttspico-utils libwebsockets-dev libsuitesparse-dev && \
    apt-get install --no-install-recommends -y \
        ros-kinetic-desktop \
        ros-kinetic-navigation \
        ros-kinetic-perception \
        ros-kinetic-stage-ros \
        ros-kinetic-gmapping \
        ros-kinetic-joy \
        ros-kinetic-joystick-drivers \
        ros-kinetic-audio-common \
        ros-kinetic-libuvc \
        ros-kinetic-rgbd-launch \
        ros-kinetic-web-video-server && \
    rm -rf /var/lib/apt/lists/*

COPY pulse-client.conf /etc/pulse/client.conf


# User: robot (password: robot) with sudo power

RUN useradd -ms /bin/bash robot && echo "robot:robot" | chpasswd && adduser robot sudo

RUN adduser robot audio
RUN adduser robot video
RUN adduser robot dialout


###### User robot ######

USER robot

# Configuration

RUN echo "set -g mouse on" > $HOME/.tmux.conf

RUN mkdir -p $HOME/.config/pulse && \
    cd $HOME/.config/pulse && \
    ln -s /opt/config/pulse/cookie .

RUN mkdir -p $HOME/Downloads


# Python packages

RUN pip install --no-cache-dir --user sox==1.3.7 pyalsaaudio==0.8.4

RUN if [ "$MACHTYPE" = "x86_64" ]; then \
        pip install --no-cache-dir --user setuptools==44 scipy==1.2.1 numpy==1.16.6 \
                       markdown==2.6.8 tensorflow==1.13.1 keras==2.2.4 \
                       np_utils==0.5.12.1 mock==1.0.0; \
    fi

RUN pip install --no-cache-dir --user tornado==5.0.2

# Init ROS workspace

RUN mkdir -p $HOME/ros/catkin_ws/src

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash; cd $HOME/ros/catkin_ws/src; catkin_init_workspace; cd ..; catkin_make"

RUN echo "source \$HOME/ros/catkin_ws/devel/setup.bash" >> $HOME/.bashrc

RUN rosdep update

RUN /bin/bash -ci "cd $HOME/ros/catkin_ws; catkin_make"


# Set working dir and container command

WORKDIR /home/robot

CMD /usr/bin/tmux

