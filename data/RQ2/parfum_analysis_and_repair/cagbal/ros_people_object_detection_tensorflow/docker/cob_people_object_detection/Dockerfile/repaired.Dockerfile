FROM ros:kinetic
LABEL maintainer "cagatay.odabasi@ipa.fraunhofer.de"

RUN apt-get update && apt-get install --no-install-recommends -y libopencv-dev \
    git \
    protobuf-compiler \
    python-pip && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /root/catkin_ws/src

# Install the package
WORKDIR /root/catkin_ws/src

RUN git clone --recursive https://github.com/cagbal/cob_people_object_detection_tensorflow.git

RUN git clone https://github.com/cagbal/cob_perception_common.git

WORKDIR /root/catkin_ws/src/cob_people_object_detection_tensorflow/src

RUN protoc object_detection/protos/anchor_generator.proto --python_out=.

WORKDIR /root/catkin_ws

#RUN apt-key update && apt-get update && rosdep install --from-path /root/catkin_ws/src/ -y -i


#
RUN apt-get update && apt-get install --no-install-recommends -y --allow-unauthenticated \
     ros-kinetic-cv-bridge \
     ros-kinetic-eigen-conversions \
     ros-kinetic-image-transport \
     ros-kinetic-pcl-ros && rm -rf /var/lib/apt/lists/*;

# Build
RUN /bin/bash -c 'source /opt/ros/kinetic/setup.bash && catkin_make'


# Install packages with pip
RUN pip install --no-cache-dir --upgrade --force-reinstall pip==9.0.3

RUN pip install --no-cache-dir tensorflow \
    scipy \
    filterpy \
    matplotlib \
    face_recognition \
    numba \
    sklearn

