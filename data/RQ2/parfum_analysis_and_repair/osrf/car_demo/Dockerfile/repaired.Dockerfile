FROM osrf/ros:kinetic-desktop

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    wget \
    lsb-release \
    sudo \
    mesa-utils \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;


# Get gazebo binaries
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list \
 && wget https://packages.osrfoundation.org/gazebo.key -O - | apt-key add - \
 && apt-get update \
 && apt-get install --no-install-recommends -y \
    gazebo9 \
    ros-kinetic-gazebo9-ros-pkgs \
    ros-kinetic-fake-localization \
    ros-kinetic-joy \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;


RUN mkdir -p /tmp/workspace/src
COPY prius_description /tmp/workspace/src/prius_description
COPY prius_msgs /tmp/workspace/src/prius_msgs
COPY car_demo /tmp/workspace/src/car_demo
RUN /bin/bash -c 'cd /tmp/workspace \
 && source /opt/ros/kinetic/setup.bash \
 && catkin_make'


CMD ["/bin/bash", "-c", "source /opt/ros/kinetic/setup.bash && source /tmp/workspace/devel/setup.bash && roslaunch car_demo demo.launch"]
