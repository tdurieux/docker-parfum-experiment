# To build:
# docker build --pull --no-cache --tag flock2:foxy .

# To run:
# docker run -it flock2:foxy bash

# I'm using this for smoke tests
# To run flock2 in a docker container you will need to set up ports, x-windows, etc.

FROM osrf/ros:foxy-desktop

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install --no-install-recommends -y libasio-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN yes | pip3 install --no-cache-dir 'transformations==2018.9.5'

WORKDIR /work/flock2_ws/src

RUN git clone https://github.com/clydemcqueen/flock2.git
RUN git clone https://github.com/clydemcqueen/tello_ros.git
RUN git clone https://github.com/ptrmu/ros2_shared.git
RUN git clone https://github.com/ptrmu/fiducial_vlam.git

WORKDIR /work/flock2_ws

RUN rosdep install -y --from-paths . --ignore-src

RUN /bin/bash -c "source /opt/ros/foxy/setup.bash && colcon build"
