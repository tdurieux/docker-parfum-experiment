FROM ros:kinetic-ros-base

ENV DEBIAN_FRONTEND=noninteractive
RUN n=$(dpkg-query -W #####DEB_PACKAGE##### | grep -cv "no packages found"); \
    if [ $n -eq 0 ]; then apt-get update; fi
RUN n=$(dpkg-query -W #####DEB_PACKAGE##### | grep -cv "no packages found"); \
    if [ $n -eq 0 ]; then apt-get install -y #####DEB_PACKAGE#####; fi

RUN sed -i "6iexport ROS_IP=\$\(hostname -I\)" /ros_entrypoint.sh

RUN rm -rf /var/lib/apt/lists/*

CMD #####CMD#####