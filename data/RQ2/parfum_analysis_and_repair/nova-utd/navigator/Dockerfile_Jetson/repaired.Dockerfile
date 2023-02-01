ARG OVERLAY_WS=/opt/ws

# The secret sauce for cross-compilation for the Jetson
FROM nvidia/l4t-base:r32.2.1

# clone overlay source
ARG OVERLAY_WS
WORKDIR $OVERLAY_WS
COPY rosdep.sh /tmp/rosdep.sh
RUN apt-get update && \
    apt-get install -y --no-install-recommends ros-foxy-desktop-full && \
    . /opt/ros/$ROS_DISTRO/setup.sh && \
    apt install --no-install-recommends -y git cmake python3-pip && \
    pip3 install --no-cache-dir -U colcon-common-extensions vcstool && rm -rf /var/lib/apt/lists/*;

ENV DEBIAN_FRONTEND noninteractive

RUN /tmp/rosdep.sh && rm -rf /var/lib/apt/lists/*

# RUN echo "\
# repositories: \n\
#   ros2/demos: \n\
#     type: git \n\
#     url: https://github.com/ros2/demos.git \n\
#     version: ${ROS_DISTRO} \n\
# " > ../overlay.repos
# RUN vcs import ./ < ../overlay.repos

# copy manifests for caching
# WORKDIR /opt
# RUN mkdir -p /tmp/opt && \
#     find ./ -name "package.xml" | \
#       xargs cp --parents -t /tmp/opt && \
#     find ./ -name "COLCON_IGNORE" | \
#       xargs cp --parents -t /tmp/opt || true
WORKDIR $OVERLAY_WS

COPY src/ src/
RUN apt update && rosdep update && rosdep install -y --from-paths src --ignore-src
RUN apt update && apt install -y --no-install-recommends ros-foxy-lgsvl-bridge && rm -rf /var/lib/apt/lists/*;
# install overlay dependencies


# COPY --from=cacher $OVERLAY_WS/src ./src


# build overlay source
# COPY --from=cacher $OVERLAY_WS/src ./src
# ARG OVERLAY_MIXINS="release"
# RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
#     colcon build \
#       --packages-select \
#         demo_nodes_cpp \
#         demo_nodes_py \
#       --mixin $OVERLAY_MIXINS
ENV ROS_VERSION 2

RUN . /opt/ros/foxy/setup.sh && colcon build

# source entrypoint setup
# ENV OVERLAY_WS $OVERLAY_WS
# RUN sed --in-place --expression \
#       '$isource "$OVERLAY_WS/install/setup.bash"' \
#       /ros_entrypoint.sh

# run launch file

COPY param/ param/
COPY data/ data/
COPY main.launch.py main.launch.py

ENV OVERLAY_WS $OVERLAY_WS
RUN sed --in-place --expression \
      '$isource "$OVERLAY_WS/install/setup.bash"' \
      /ros_entrypoint.sh

CMD ["ros2", "launch", "main.launch.py"]