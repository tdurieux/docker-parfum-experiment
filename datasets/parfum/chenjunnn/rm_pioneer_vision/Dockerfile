FROM ros:galactic-ros-base

# install tools
RUN apt-get update && apt dist-upgrade -y && \
    apt-get install -y wget vim htop \
    ros-galactic-xacro ros-galactic-camera-info-manager ros-galactic-rosbridge-server \
    ros-galactic-joint-state-publisher ros-galactic-compressed-image-transport ros-galactic-usb-cam && \
    rm -rf /var/lib/apt/lists/*

# setup zsh
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.2/zsh-in-docker.sh)" -- \
    -t jispwoso -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting && \
    chsh -s /bin/zsh && \
    rm -rf /var/lib/apt/lists/*

# create workspace
RUN mkdir -p /ros_ws/src
WORKDIR /ros_ws/

# copy source code
COPY . src/rm_vision

# install dependencies
RUN apt-get update && \
    rosdep install --from-paths src --ignore-src -r -y \
    && rm -rf /var/lib/apt/lists/*

# build source
RUN . /opt/ros/galactic/setup.sh && colcon build --symlink-install

# setup scripts
COPY scripts scripts
RUN cat scripts/zshrc >> /root/.zshrc && rm -r scripts
