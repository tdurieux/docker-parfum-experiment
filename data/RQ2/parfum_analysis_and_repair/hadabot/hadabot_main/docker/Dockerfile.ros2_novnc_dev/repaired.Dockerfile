# docker build -t hadabot/ros2-nav2-vnc
# docker run --rm -p 6080:80 -p 5901:5900 -v /dev/shm:/dev/shm -v `pwd`/navigation2:/root/navigation_ws/src/navigation2:ro hadabot/ros2-nav2-vnc

ARG FROM_IMAGE=dorowu/ubuntu-desktop-lxde-vnc

FROM $FROM_IMAGE AS cache

RUN apt-get update && \
    apt-get install --no-install-recommends -y locales curl gnupg2 lsb-release wget git && \
    locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    curl -f -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && \
    sh -c 'echo "deb http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list' && \
    rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8

RUN apt-get update && apt-get install --no-install-recommends -y ros-eloquent-desktop ros-eloquent-navigation2 ros-eloquent-nav2-bringup && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install --no-install-recommends -y \
     google-mock \
	libceres-dev \
	liblua5.3-dev \
	libboost-dev \
	libboost-iostreams-dev \
	libprotobuf-dev \
	protobuf-compiler \
	libcairo2-dev \
	libpcl-dev \
	python3-sphinx && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install --no-install-recommends -y gazebo9 libgazebo9-dev ros-eloquent-gazebo-* ros-eloquent-cartographer ros-eloquent-cartographer-ros && \
    apt-get install --no-install-recommends -y python3-vcstool python3-colcon-common-extensions && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    mkdir -p /root/turtlebot3_ws/src && \
    cd /root/turtlebot3_ws && \
    wget https://raw.githubusercontent.com/ROBOTIS-GIT/turtlebot3/ros2/turtlebot3.repos && \
    vcs import src < turtlebot3.repos && \
    rm -rf /var/lib/apt/lists/*