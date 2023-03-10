ARG ROS_DISTRO
ARG ROS_ARCH
from ${ROS_ARCH}/ros:${ROS_DISTRO}

ARG ROS_DISTRO
ARG ROS_ARCH
ARG ROS=ros-${ROS_DISTRO}
ARG USR

SHELL ["/bin/bash", "-c"]


RUN if [ "$USR" == "build" ]; then \
	apt-get update && apt-get install --no-install-recommends -y \
              ${ROS}-rosdoc-lite \
                                ${ROS}-tf2-geometry-msgs \
                                ${ROS}-gps-common \
                                ${ROS}-nav-msgs \
                                ${ROS}-nmea-msgs \
                                dh-make fakeroot python3-pip && \
                                pip3 install --no-cache-dir bloom \
; rm -rf /var/lib/apt/lists/*; fi

RUN apt-get update && apt-get install --no-install-recommends -y sudo vim nano && rm -rf /var/lib/apt/lists/*;

# Uncomment this to support building .debs for new ROS distros, where we are not in the index yet; add distro to yaml.
# RUN echo "yaml file:///home/build/docker/rosdep.yaml" > /etc/ros/rosdep/sources.list.d/50-local-packages.list

RUN groupadd -g 1000 ${USR}
RUN useradd -u 1000 -g 1000 -G sudo,${USR},dialout -ms /bin/bash ${USR}
RUN echo "${USR}:${USR}" | chpasswd
USER ${USR}

CMD "/bin/bash"

