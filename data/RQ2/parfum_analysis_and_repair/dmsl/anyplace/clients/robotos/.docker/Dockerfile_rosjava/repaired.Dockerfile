FROM osrf/ros:kinetic-desktop-full

WORKDIR /root/catkin_ws

SHELL ["/bin/bash", "-c"]

RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc

RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-utils \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential \
    git \
    ros-kinetic-catkin \
    ros-kinetic-rospack \
    ros-kinetic-dynamic-reconfigure \
    net-tools \
    wireless-tools \
    ros-kinetic-rospy-message-converter && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /root/rosjava/src

RUN wstool init -j4 ~/rosjava/src https://raw.githubusercontent.com/rosjava/rosjava/kinetic/rosjava.rosinstall

# RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; cd /root/rosjava; catkin_make'

RUN echo "source ~/rosjava/devel/setup.bash" >> ~/.bashrc

WORKDIR /root/rosjava

RUN rosdep update

RUN rosdep install --from-paths src -i -r -y

# RUN apt-get clean

RUN /bin/bash -c '. /opt/ros/kinetic/setup.bash; . /root/rosjava/devel/setup.bash; cd /root/rosjava; catkin_make'

