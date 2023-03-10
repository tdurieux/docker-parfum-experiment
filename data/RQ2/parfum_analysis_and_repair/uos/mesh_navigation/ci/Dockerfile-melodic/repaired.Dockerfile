FROM ubuntu:bionic

# setup env
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV ROS_DISTRO melodic

RUN apt update
RUN apt install -q -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*;

# setup timezone
RUN echo 'Etc/UTC' > /etc/timezone
RUN ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime
RUN apt install -q -y --no-install-recommends tzdata && rm -rf /var/lib/apt/lists/*;

# setup ROS
RUN apt install -q -y --no-install-recommends dirmngr gnupg2 curl ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros-latest.list'

# barebones ros installation
# - we want all packages to be installed as dependencies of our packages
RUN apt update
RUN apt install -q -y --no-install-recommends ros-${ROS_DISTRO}-ros && rm -rf /var/lib/apt/lists/*;
RUN apt install -q -y --no-install-recommends python-rosdep && rm -rf /var/lib/apt/lists/*;

# install catkin
RUN apt install -q -y --no-install-recommends python-catkin-tools && rm -rf /var/lib/apt/lists/*;
RUN apt install -q -y --no-install-recommends python-catkin-lint && rm -rf /var/lib/apt/lists/*;

# setup workspace
COPY . /catkin_ws/src/mesh_navigation
WORKDIR /catkin_ws

# install package dependencies
RUN rosdep init && rosdep update && rosdep install --from-paths src -i -y --rosdistro $ROS_DISTRO

# build workspace
RUN /bin/bash -c "source /opt/ros/${ROS_DISTRO}/setup.bash && \
    catkin init && \
    catkin build -v --no-notify"

# remove apt update results
RUN rm -rf /var/lib/apt/lists/*

# make docker source the ros installation
COPY ci/docker_entrypoint.sh /
ENTRYPOINT ["/docker_entrypoint.sh"]
CMD ["bash"]
