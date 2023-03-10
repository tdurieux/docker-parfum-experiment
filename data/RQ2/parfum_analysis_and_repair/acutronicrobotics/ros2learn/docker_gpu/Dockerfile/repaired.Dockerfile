FROM nvidia/cuda:10.0-devel-ubuntu18.04

# FROM tensorflow/tensorflow:latest-gpu-py3

LABEL maintainer="Lander Usategui <lander at erlerobotics dot com>"

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV CUDNN_VERSION 7.5.1.10

ENV ROS2_DISTRO dashing
#Prepare work-space
RUN mkdir -p /root/ros2_mara_ws/src
WORKDIR /root/ros2_mara_ws

RUN \
     echo 'Etc/UTC' > /etc/timezone \
      && ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime \
      && apt-get update -qq && apt-get install --no-install-recommends -qq -y tzdata dirmngr gnupg2 lsb-release curl \
      # setup ros2 keys
      && curl -f https://repo.ros2.org/repos.key | apt-key add - \
      # setup sources.list
      && echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list \
      && apt-get update -qq && apt-get install --no-install-recommends -qq -y \
        build-essential \
        cuda-libraries-dev-$CUDA_PKG_VERSION \
        cuda-nvml-dev-$CUDA_PKG_VERSION \
        cuda-minimal-build-$CUDA_PKG_VERSION \
        cuda-command-line-tools-$CUDA_PKG_VERSION \
        libnccl-dev=$NCCL_VERSION-1+cuda10.0 \
        libcudnn7=$CUDNN_VERSION-1+cuda10.0 \
        libcudnn7-dev=$CUDNN_VERSION-1+cuda10.0 \
        cmake \
        git \
        python3-colcon-common-extensions \
        python3-pip \
        python3-vcstool \
        wget \
      && pip3 install --no-cache-dir \
        tensorflow-gpu \
        transforms3d \
        billiard \
        psutil \
      && apt-mark hold libcudnn7 \
      && apt update -qq && apt install --no-install-recommends -qq -y \
        python3-colcon-common-extensions \
        python3-vcstool \
        python3-numpy \
        python3-sip-dev \
        python3-tk \
        libeigen3-dev \
        wget \
        libboost-all-dev \
        ros-$ROS2_DISTRO-ros-base \
        ros-$ROS2_DISTRO-action-msgs \
        ros-$ROS2_DISTRO-message-filters \
        ros-$ROS2_DISTRO-yaml-cpp-vendor \
        ros-$ROS2_DISTRO-urdf \
        ros-$ROS2_DISTRO-rttest \
        ros-$ROS2_DISTRO-tf2 \
        ros-$ROS2_DISTRO-tf2-geometry-msgs \
        ros-$ROS2_DISTRO-rclcpp-action \
        ros-$ROS2_DISTRO-cv-bridge \
        ros-$ROS2_DISTRO-control-msgs \
        ros-$ROS2_DISTRO-image-transport \
        ros-$ROS2_DISTRO-gazebo-dev \
        ros-$ROS2_DISTRO-gazebo-msgs \
        ros-$ROS2_DISTRO-gazebo-plugins \
        ros-$ROS2_DISTRO-gazebo-ros \
        ros-$ROS2_DISTRO-gazebo-ros-pkgs \
        libopencv-dev \
        && rm -rf /var/lib/apt/lists/* \
      && wget https://raw.githubusercontent.com/AcutronicRobotics/MARA/dashing/mara-ros2.repos && vcs import src < mara-ros2.repos \
      && wget https://raw.githubusercontent.com/AcutronicRobotics/gym-gazebo2/dashing/provision/additional-repos.repos && vcs import src < additional-repos.repos \
      #Generete HRIM packages
      && cd ~/ros2_mara_ws/src/HRIM \
      && pip3 install --no-cache-dir hrim \
      && hrim generate models/actuator/servo/servo.xml \
      && hrim generate models/actuator/gripper/gripper.xml \
      #Compile the work-space
      && bash -c " cd /root/ros2_mara_ws \
      && source /opt/ros/dashing/setup.bash && colcon build --merge-install --parallel-workers $(nproc) --packages-ignore orocos_kinematics_dynamics individual_trajectories_bridge \
      && touch /root/ros2_mara_ws/install/share/orocos_kdl/local_setup.sh /root/ros2_mara_ws/install/share/orocos_kdl/local_setup.bash \
      && cd /root && git clone https://github.com/openai/gym && cd /root/gym && pip3 install -e . \
      #ros2learn
      && cd /root && git clone -b dashing https://github.com/AcutronicRobotics/ros2learn \
      && cd /root/ros2learn \
      && git submodule update --init --recursive \
      && git pull --recurse-submodules && git submodule update --recursive --remote \
      && cd /root/ros2learn/environments/gym-gazebo2 && pip3 install -e . \
      && cd /root/ros2learn/algorithms/baselines && pip3 install -e . \
      #Load provisioning script
      && echo 'source /root/ros2learn/environments/gym-gazebo2/provision/mara_setup.sh' >> ~/.bashrc \
      "
WORKDIR /root/ros2learn/
EXPOSE 11597
ENTRYPOINT ["bash"]
