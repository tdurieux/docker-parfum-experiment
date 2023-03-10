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

# setup keys and setup sources.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BA6932366A755776 && \
    echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros1-latest.list && \
    echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu/ focal main" > /etc/apt/sources.list.d/deadsnakes.list

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV ROS_DISTRO noetic

# ###################

RUN mkdir -p /ws/src/f1tenth_agent_ros/
WORKDIR /ws/src/f1tenth_agent_ros/

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3.6 \
    ros-noetic-ros-core=1.5.0-1* \
    python3.6 python3.6-dev python3-pip git wget unzip make gcc g++ \
    libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran libopenblas-base libopenmpi-dev \
    libopenblas-dev openmpi-bin openmpi-common \
    python3-matplotlib ros-noetic-ackermann-msgs ros-noetic-tf python3-catkin-tools python3-catkin-pkg && rm -rf /var/lib/apt/lists/*;

RUN wget https://github.com/bazelbuild/bazel/releases/download/4.0.0/bazel-4.0.0-linux-arm64 -O /bin/bazel && \
    chmod +x /bin/bazel

ARG AGENT
COPY agents/${AGENT}/requirements.car.txt requirements.txt

#
# PyTorch (for JetPack 4.4 DP)
#
#  PyTorch v1.2.0 https://nvidia.box.com/shared/static/lufbgr3xu2uha40cs9ryq1zn4kxsnogl.whl (torch-1.2.0-cp36-cp36m-linux_aarch64.whl)
#  PyTorch v1.3.0 https://nvidia.box.com/shared/static/017sci9z4a0xhtwrb4ps52frdfti9iw0.whl (torch-1.3.0-cp36-cp36m-linux_aarch64.whl)
#  PyTorch v1.4.0 https://nvidia.box.com/shared/static/c3d7vm4gcs9m728j6o5vjay2jdedqb55.whl (torch-1.4.0-cp36-cp36m-linux_aarch64.whl)
#  PyTorch v1.5.0 https://nvidia.box.com/shared/static/3ibazbiwtkl181n95n9em3wtrca7tdzp.whl (torch-1.5.0-cp36-cp36m-linux_aarch64.whl)
#  PyTorch v1.6.0 https://nvidia.box.com/shared/static/9eptse6jyly1ggt9axbja2yrmj6pbarc.whl (torch-1.6.0-cp36-cp36m-linux_aarch64.whl)
#  PyTorch v1.7.0 https://nvidia.box.com/shared/static/cs3xn3td6sfgtene6jdvsxlr366m2dhq.whl (torch-1.7.0-cp36-cp36m-linux_aarch64.whl)
#ARG PYTORCH_URL=https://nvidia.box.com/shared/static/cs3xn3td6sfgtene6jdvsxlr366m2dhq.whl
ARG PYTORCH_URL=https://nvidia.box.com/shared/static/9eptse6jyly1ggt9axbja2yrmj6pbarc.whl
#ARG PYTORCH_WHL=torch-1.7.0-cp36-cp36m-linux_aarch64.whl
ARG PYTORCH_WHL=torch-1.6.0-cp36-cp36m-linux_aarch64.whl

# install python requirements for this agent
RUN python3.6 -m pip install -U pip testresources setuptools==49.6.0 && \
    python3.6 -m pip install -U numpy==1.16.1 && \
    wget --quiet --show-progress --progress=bar:force:noscroll --no-check-certificate ${PYTORCH_URL} -O ${PYTORCH_WHL} && \
    python3.6 -m pip install ${PYTORCH_WHL} --verbose && \
    rm ${PYTORCH_WHL} && \
    python3.6 -m pip install --no-cache-dir -r requirements.txt

COPY entrypoint.sh .
COPY CMakeLists.txt .
COPY package.xml .
COPY agents/${AGENT}/src ./src
COPY helpers/* ./src/

RUN /bin/bash -c "cd /usr/bin/; rm /usr/bin/python3; ln -s python3.6 python3" && \
    /bin/bash -c "source /opt/ros/noetic/setup.bash; cd /ws; catkin build" && \
    chmod a+x src/* && chmod +x entrypoint.sh

ARG MODEL
COPY ${MODEL} src/.

WORKDIR /ws

EXPOSE 11311
ENTRYPOINT ["/ws/src/f1tenth_agent_ros/entrypoint.sh"]

CMD ["/bin/bash", "-c", "python3 ./src/f1tenth_agent_ros/src/agent.py"]


