FROM koide3/jetson-ros-noetic-desktop:jp45

# editors
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      vim nano tmux \
      && rm -rf /var/lib/apt/lists/*

# flann & openblas
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libflann-dev libopenblas-base libopenblas-dev \
      && rm -rf /var/lib/apt/lists/*

# tensorflow
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev \
        zip libjpeg8-dev liblapack-dev libblas-dev gfortran \
        python3-pip \
      && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir -U pip testresources setuptools
RUN pip3 install --no-cache-dir --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v45 "tensorflow<2"

# tf-pose-estimation
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      llvm-10 llvm-10-dev swig \
      && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-10 50
RUN pip3 install --no-cache-dir numba==0.45.0

WORKDIR /root/catkin_ws/src
RUN git clone https://github.com/koide3/tf-pose-estimation

WORKDIR /root/catkin_ws/src/tf-pose-estimation
RUN pip3 install --no-cache-dir -r requirements.txt

WORKDIR /root/catkin_ws/src/tf-pose-estimation/tf_pose/pafprocess
RUN swig -python -c++ pafprocess.i && python3 setup.py build_ext --inplace

WORKDIR /root/catkin_ws/src/tf-pose-estimation/models/graph/cmu
RUN bash download.sh

WORKDIR /root/catkin_ws/src/tf-pose-estimation
RUN pip3 install --no-cache-dir -U matplotlib
RUN python3 setup.py install

# dlib
WORKDIR /root
RUN wget https://dlib.net/files/dlib-19.22.tar.bz2
RUN tar xvf dlib-19.22.tar.bz2 && rm dlib-19.22.tar.bz2
ENV DLIB_ROOT="/root/dlib-19.22"

# other ros packages
WORKDIR /root/catkin_ws/src
RUN git clone https://github.com/ros-drivers/usb_cam.git
RUN git clone https://github.com/ros-perception/image_transport_plugins.git
RUN git clone https://github.com/ros-perception/vision_opencv.git
RUN git clone https://github.com/ros-perception/image_common.git
RUN git clone https://github.com/ros-perception/image_pipeline.git

RUN touch /root/catkin_ws/src/image_transport_plugins/theora_image_transport/CATKIN_IGNORE
RUN touch /root/catkin_ws/src/image_pipeline/stereo_image_proc/CATKIN_IGNORE

WORKDIR /root/catkin_ws
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; catkin_make -DCMAKE_BUILD_TYPE=Release'

# WORKDIR /root/catkin_ws/src
# RUN https://github.com/ros/geometry.git

# WORKDIR /root/catkin_ws
# RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; catkin_make -DCMAKE_BUILD_TYPE=Release'


# monocular_person_following
WORKDIR /root/catkin_ws/src
RUN git clone https://github.com/koide3/open_face_recognition.git
RUN git clone https://github.com/koide3/ccf_person_identification.git
RUN git clone https://github.com/koide3/monocular_people_tracking.git --recursive
RUN git clone https://github.com/koide3/monocular_person_following.git

WORKDIR /root/catkin_ws
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; catkin_make -DCMAKE_BUILD_TYPE=Release'
RUN sed -i "7i source \"/root/catkin_ws/devel/setup.bash\"" /ros_entrypoint.sh

WORKDIR /root/catkin_ws/src

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
