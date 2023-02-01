ARG ROS_DISTRO
ARG UBUNTU_VERSION
FROM osrf/ros:${ROS_DISTRO}-desktop-${UBUNTU_VERSION}
ENV DEBIAN_FRONTEND noninteractive

RUN if [ -f "/etc/apt/sources.list.d/ros-latest.list" ]; then \
      mv /etc/apt/sources.list.d/ros-latest.list /etc/apt/sources.list.d/ros-latest.list.save; \
    fi
RUN if [ -f "/etc/apt/sources.list.d/ros1-latest.list" ]; then \
      mv /etc/apt/sources.list.d/ros1-latest.list /etc/apt/sources.list.d/ros1-latest.list.save; \
    fi
RUN apt-get update && apt-get install --no-install-recommends -y wget curl git && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
# RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros1-latest.list
RUN echo "deb http://packages.ros.org/ros-testing/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros1-latest.list

# FIXME: https://github.com/start-jsk/jsk_apc/pull/2664
RUN apt-get update && apt-get dist-upgrade -y && \
    if [ ${ROS_DISTRO} = "noetic" ]; then \
      apt-get install --no-install-recommends -y \
      apt-utils \
      python3-catkin-tools \
      python3-rosdep \
      python3-setuptools \
      python3-wstool \
      python3-pip; \
    else \
      apt-get install --no-install-recommends -y \
      apt-utils \
      python-catkin-tools \
      python-rosdep \
      python-setuptools \
      python-wstool \
      python-pip; \
    fi && \
    rm -rf /var/lib/apt/lists/*

RUN if [ ${ROS_DISTRO} != "noetic" ]; then \
      pip install --no-cache-dir pip==9.0.3; \
      pip install --no-cache-dir setuptools==44.1.0; \
    fi

RUN apt-get update && \
    apt-get install --no-install-recommends -y apt-transport-https ca-certificates && \
    echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list && \
    curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && \
    apt-get install --no-install-recommends -y libedgetpu1-legacy-std python3-edgetpu python3-pip && \
    rm -rf /var/lib/apt/lists/*

ARG ROS_DISTRO
RUN apt-get update && \
    if [ ${ROS_DISTRO} = "noetic" ]; then \
      apt-get install -y --no-install-recommends python3-tflite-runtime; \
    elif [ ${ROS_DISTRO} = "melodic" ]; then \
      wget https://dl.google.com/coral/python/tflite_runtime-1.14.0-cp36-cp36m-linux_x86_64.whl && \
      pip3 install --no-cache-dir tflite_runtime-1.14.0-cp36-cp36m-linux_x86_64.whl; \
      apt-get install -y --no-install-recommends python3-opencv; \
    elif [ ${ROS_DISTRO} = "kinetic" ]; then \
      wget https://dl.google.com/coral/python/tflite_runtime-1.14.0-cp35-cp35m-linux_x86_64.whl && \
      pip3 install --no-cache-dir tflite_runtime-1.14.0-cp35-cp35m-linux_x86_64.whl; \
      pip3 install --no-cache-dir --user opencv-python==4.2.0.32 numpy\<1.19.0; \
    fi && \
    rm -rf /var/lib/apt/lists/*

ARG ROS_DISTRO
RUN cd ~ && \
    mkdir -p ros/${ROS_DISTRO}/src && \
    cd ros/${ROS_DISTRO}/src && \
    wstool init && \
    wstool set coral_usb_ros https://github.com/jsk-ros-pkg/coral_usb_ros.git -v master --git -y && \
    wstool up -j 2 && \
    wstool merge -y coral_usb_ros/fc.rosinstall && \
    if [ -f coral_usb_ros/fc.rosinstall.${ROS_DISTRO} ]; then \
      wstool merge -y coral_usb_ros/fc.rosinstall.${ROS_DISTRO}; \
    fi && \
    wstool up -j 2

RUN if [ ${ROS_DISTRO} != "noetic" ]; then \
      pip install --no-cache-dir dlib==19.21.1; \
      pip install --no-cache-dir fcn chainercv chainer==6.7.0 protobuf==3.18.0; \
    fi

# /opt/ros/${ROS_DISTRO}/share can be changed after rosdep install, so we run it 3 times.
RUN rosdep update --include-eol-distros && \
    apt-get update && \
    for i in $(seq 3); do \
      rosdep install --rosdistro ${ROS_DISTRO} -r -y -i --from-paths /opt/ros/${ROS_DISTRO}/share ~/ros/${ROS_DISTRO}/src; \
    done && \
    rm -rf /var/lib/apt/lists/*

ARG ROS_DISTRO
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
    cd ~/ros/${ROS_DISTRO} && \
    if [ ${ROS_DISTRO} = "kinetic" ] ; then \
      catkin config -DPYTHON_EXECUTABLE=/usr/bin/python3 -DPYTHON_INCLUDE_DIR=/usr/include/python3.5m -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.5m.so; \
    fi && \
    catkin build
