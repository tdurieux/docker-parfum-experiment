FROM ros:lunar-ros-base

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
    ros-lunar-cv-bridge \
    ros-lunar-opencv3 \
    ros-lunar-tf \
    python-pip python-matplotlib \
  && rm -rf /var/lib/apt/lists/*
COPY . /kitti2bag
RUN pip install --no-cache-dir -e /kitti2bag

WORKDIR /data

ENTRYPOINT ["/kitti2bag/docker_entrypoint.sh"]

