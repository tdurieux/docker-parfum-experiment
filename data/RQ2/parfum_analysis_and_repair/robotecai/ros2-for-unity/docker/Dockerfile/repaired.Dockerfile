ARG ROS2_DISTRO=humble
FROM ros:${ROS2_DISTRO}-ros-base

RUN apt update && apt install --no-install-recommends -y ros-${ROS_DISTRO}-test-msgs ros-${ROS_DISTRO}-fastrtps ros-${ROS_DISTRO}-rmw-fastrtps-cpp ros-${ROS_DISTRO}-cyclonedds ros-${ROS_DISTRO}-rmw-cyclonedds-cpp && rm -rf /var/lib/apt/lists/*;

RUN apt update && apt install --no-install-recommends -y curl wget git && rm -rf /var/lib/apt/lists/*;

RUN curl -f -s https://packagecloud.io/install/repositories/dirk-thomas/vcstool/script.deb.sh | sudo bash
RUN apt update && apt install --no-install-recommends -y python3-vcstool && rm -rf /var/lib/apt/lists/*;

RUN wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt update && apt install --no-install-recommends -y apt-transport-https patchelf; rm -rf /var/lib/apt/lists/*; if [ "$(lsb_release -rs)" = "22.04" ] ; then \
 apt install --no-install-recommends -y dotnet-sdk-6.0; else apt install --no-install-recommends -y dotnet-sdk-3.1; fi
RUN apt update && apt install --no-install-recommends -y ffmpeg libsm6 libxext6 libgtk-3-0 && rm -rf /var/lib/apt/lists/*;

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN mkdir -p /workdir/ros2-for-unity
RUN chmod -R 777 /workdir
RUN chmod -R 777 /home

ENTRYPOINT [ "/entrypoint.sh" ]
