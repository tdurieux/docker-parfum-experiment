# FROM ros:noetic-ros-core
# FROM ros:melodic-ros-core


# ##################
# parts taken from: https://github.com/osrf/docker_images/blob/df19ab7d5993d3b78a908362cdcd1479a8e78b35/ros/noetic/ubuntu/focal/ros-core/Dockerfile

# This is an auto generated Dockerfile for ros:ros-core
# generated from docker_images/create_ros_core_image.Dockerfile.em
FROM ubuntu:focal

# setup timezone
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*

# install packages
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BA6932366A755776

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros1-latest.list
RUN echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu/ focal main" > /etc/apt/sources.list.d/deadsnakes.list

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV ROS_DISTRO noetic

# install ros packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.6 \
    ros-noetic-ros-core=1.5.0-1* \
    && rm -rf /var/lib/apt/lists/*

# ###################

RUN mkdir -p /ws/src/f1tenth_agent_ros/
WORKDIR /ws/src/f1tenth_agent_ros/
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3.6 python3.6-dev python3-pip git wget unzip make gcc g++ \
    libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran && rm -rf /var/lib/apt/lists/*;
#    rm -rf /var/lib/apt/lists/*

# install python requirements for this agent
ARG AGENT
COPY agents/${AGENT}/requirements.txt .
RUN python3.6 -m pip install --no-cache-dir -r requirements.txt

RUN apt-get install -y --no-install-recommends ros-noetic-ackermann-msgs ros-noetic-tf python3-catkin-tools python3-catkin-pkg && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh .
COPY CMakeLists.txt .
COPY package.xml .
COPY agents/${AGENT}/src ./src
COPY helpers/* ./src/

RUN /bin/bash -c "cd /usr/bin/; rm /usr/bin/python3; ln -s python3.6 python3"
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash; cd /ws; catkin build"
RUN chmod a+x src/* && chmod +x entrypoint.sh

ARG MODEL
COPY ${MODEL} src/.

WORKDIR /ws

EXPOSE 11311
ENTRYPOINT ["/ws/src/f1tenth_agent_ros/entrypoint.sh"]

CMD ["/bin/bash", "-c", "python3 ./src/f1tenth_agent_ros/src/agent.py"]


