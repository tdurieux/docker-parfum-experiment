# use ros base image as default
ARG BASE_IMAGE=ros:galactic-ros-base
FROM ${BASE_IMAGE}

# install autopep8 & wget
RUN apt-get update && \
    apt-get install -y python3-autopep8 wget && \
    rm -rf /var/lib/apt/lists/*

# setup zsh
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.2/zsh-in-docker.sh)" -- \
    -t jispwoso \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-syntax-highlighting && \
    chsh -s /bin/zsh && \
    rm -rf /var/lib/apt/lists/*

# create workspace
RUN mkdir -p /root/ros_ws/src
WORKDIR /root/ros_ws/

# copy source code
COPY . src/rm_pioneer_vision
# copy scripts
COPY .docker/* .

# install dependencies
RUN apt-get update && \
    apt-get install -y ros-galactic-xacro ros-galactic-camera-info-manager && \
    rosdep install --from-paths src --ignore-src -r -y \
    && rm -rf /var/lib/apt/lists/*

# build source
RUN . /opt/ros/galactic/setup.sh && \
    colcon build \
    --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
    --symlink-install

RUN cat .zshrc >> /root/.zshrc

ENV ROBOT=standard3

ENTRYPOINT [ "/bin/zsh", "entrypoint.sh" ]

CMD [ "./startup.sh" ]
