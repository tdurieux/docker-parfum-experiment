# Use the existing ros-noetic image
FROM osrf/ros:noetic-desktop-full

LABEL maintainer="Jose Cisneros <A01283070@itesm.mx>"

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    unzip \
    wget \
    nano \
    git \
    autoconf \
    libtool \
    python3-pip \
    mesa-utils \
    --no-install-recommends terminator \
    ros-noetic-audio-common \
    ros-noetic-moveit-ros-planning \
    ros-noetic-moveit-ros-planning-interface \
    ros-noetic-moveit-core \
    ros-noetic-moveit-msgs \
    ros-noetic-move-base && \
    rm -rf /var/lib/apt/lists/*

# Init catkin_home directoy
RUN mkdir /catkin_home
COPY catkin_home/ catkin_home/

# Change Workdir
WORKDIR /catkin_home

# Object Detection Dependencies
# Anaconda
RUN cd /tmp && curl -f https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh --output anaconda.sh && \
    sha256sum anaconda.sh && bash anaconda.sh -b && /root/anaconda3/bin/conda init

# catkin_make
RUN /bin/bash -c 'cd /catkin_home && . /opt/ros/noetic/setup.bash;catkin_make'

# Add ROS environment variables automatically
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
RUN echo "[ -f /catkin_home/devel/setup.bash ] && source /catkin_home/devel/setup.bash" >> ~/.bashrc
RUN echo "export GAZEBO_MODEL_PATH=/catkin_home/src/simulation/models:$GAZEBO_MODEL_PATH" >> ~/.bashrc
RUN echo "export GAZEBO_RESOURCE_PATH=/catkin_home/src/simulation:$GAZEBO_RESOURCE_PATH" >> ~/.bashrc

ENTRYPOINT [ "/bin/bash", "-l", "-c" ]
