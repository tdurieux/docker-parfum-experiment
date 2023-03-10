ARG ROS_DISTRO=melodic
FROM ros:${ROS_DISTRO}-ros-base

#COPY NVIDIA-DRIVER.run /tmp/NVIDIA-DRIVER.run

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Install Nvidia drivers related tools \
    && apt-get -y --no-install-recommends install kmod mesa-utils binutils \
    #
    # Verify git, process tools, lsb-release (useful for CLI installs) installed
    && apt-get -y --no-install-recommends install git iproute2 procps lsb-release \
    #
    # Install C++ tools
    && apt-get -y --no-install-recommends install build-essential cmake cppcheck valgrind \
    # Install ROS packages
    && apt-get -y --no-install-recommends install ros-${ROS_DISTRO}-pcl-ros ros-${ROS_DISTRO}-rviz \
    #
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support for the non-root user
    && apt-get install --no-install-recommends -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && echo 'source /opt/ros/$ROS_DISTRO/setup.bash' >> /home/user/.bashrc && rm -rf /var/lib/apt/lists/*;
    #
    #
    # Install nvidia driver. Run download.bash before.
    #&& sh /tmp/NVIDIA-DRIVER.run -a -N --ui=none --no-kernel-module && rm /tmp/NVIDIA-DRIVER.run \
    #&& ln -s /usr/lib/libGL.so.1 /usr/lib/x86_64-linux-gnu/libGL.so

RUN if [ "$ROS_DISTRO" = "noetic" ] \
    ; then \
          apt-get -y --no-install-recommends install python3-pip \
          && pip3 install --no-cache-dir git+https://github.com/catkin/catkin_tools.git \
    ; rm -rf /var/lib/apt/lists/*; else \
      apt-get -y --no-install-recommends install python-catkin-tools \
    ; rm -rf /var/lib/apt/lists/*; fi

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

USER user
ENTRYPOINT ["/ros_entrypoint.sh"]
