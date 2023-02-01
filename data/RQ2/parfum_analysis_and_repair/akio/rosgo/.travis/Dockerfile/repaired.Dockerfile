ARG ROS_DOCKER=ros:kinetic-ros-base
FROM $ROS_DOCKER

RUN apt-get update && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

VOLUME /usr/local/go

RUN mkdir -p src/github.com/akio/rosgo
COPY . src/github.com/akio/rosgo
COPY .travis/entrypoint.sh ./entrypoint.sh

CMD ./entrypoint.sh
