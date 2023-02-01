FROM ros:dashing

LABEL maintainer="Asier Bilbao <asier at erlerobotics dot com>"

ENV ROS2_DISTRO dashing
WORKDIR /home/root/ros2_ws
COPY ./docker-entrypoint.sh /

RUN \
      apt update -qq && apt install --no-install-recommends pep8 -y \
      && mkdir -p ros2_ws/src && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/docker-entrypoint.sh"]