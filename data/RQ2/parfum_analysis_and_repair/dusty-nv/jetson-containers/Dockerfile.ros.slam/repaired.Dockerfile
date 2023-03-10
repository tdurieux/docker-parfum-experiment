#
# ROS2 with ORBSLAM2, RTABMap, ZED, and Realsense2
#
ARG BASE_IMAGE=dustynv/ros:foxy-ros-base-pytorch-l4t-r32.5.0
FROM ${BASE_IMAGE}

SHELL ["/bin/bash", "-c"] 
ENV SHELL /bin/bash

ENV DEBIAN_FRONTEND=noninteractive
ARG MAKEFLAGS=-j$(nproc)
ENV LANG=en_US.UTF-8 
ENV PYTHONIOENCODING=utf-8
RUN locale-gen en_US en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

ENV PYTORCH_PATH="/usr/local/lib/python3.6/dist-packages/torch"
ENV LD_LIBRARY_PATH="${PYTORCH_PATH}/lib:${LD_LIBRARY_PATH}"

ARG ROS_ENVIRONMENT=${ROS_ROOT}/install/setup.bash


# 
# upgrade cmake - https://stackoverflow.com/a/56690743
# this is needed for rtabmap which uses FindPython3.cmake
#
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		  software-properties-common \
		  apt-transport-https \
		  ca-certificates \
		  gnupg \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean
		  
RUN wget -qO - https://apt.kitware.com/keys/kitware-archive-latest.asc | apt-key add - && \
    apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' && \
    apt-get update && \
    apt-get install -y --only-upgrade --no-install-recommends \
            cmake \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && cmake --version
    

#
# orbslam2 - https://github.com/alsora/ros2-ORB_SLAM2
# TODO build https://github.com/DrTimothyAldenDavis/SuiteSparse from source for CUDA if any advantage?
#
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
            ffmpeg \
            libglew-dev \
		  libboost-all-dev \
		  libboost-system-dev \
		  libcanberra-gtk-module \
            libsuitesparse-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# pangolin
RUN git clone https://github.com/stevenlovegrove/Pangolin /tmp/pangolin && \
    cd /tmp/pangolin && \
    mkdir build && \
    cd build && \
    cmake ../ && \
    make -j$(nproc) && \
    make install 
    
# orbslam2
#ENV ORB_SLAM2_ROOT_DIR="/opt/ORB_SLAM2"
#RUN git clone https://github.com/Windfisch/ORB_SLAM2 ${ORB_SLAM2_ROOT_DIR} && \
#    cd ${ORB_SLAM2_ROOT_DIR} && \
#    wget --no-check-certificate https://github.com/alsora/ros2-ORB_SLAM2/raw/master/docker/scripts/build.sh && \
#    wget --no-check-certificate https://github.com/alsora/ros2-ORB_SLAM2/raw/master/docker/scripts/orbslam.patch && \
#    git apply orbslam.patch && \
#    bash build.sh 
    
ENV ORB_SLAM2_ROOT_DIR="/opt/ORB_SLAM2_CUDA"
RUN git clone https://github.com/dusty-nv/ORB_SLAM2_CUDA ${ORB_SLAM2_ROOT_DIR} && \
    cd ${ORB_SLAM2_ROOT_DIR} && \
    bash build.sh && \
    ln -s ${ORB_SLAM2_ROOT_DIR}/lib/libORB_SLAM2_CUDA.so ${ORB_SLAM2_ROOT_DIR}/lib/libORB_SLAM2.so

# ros2_orbslam
RUN source ${ROS_ENVIRONMENT} && \
    cd ${ROS_ROOT} && \
    mkdir -p src/slam && \
    git clone https://github.com/alsora/ros2-ORB_SLAM2 src/slam/ros2-ORB_SLAM2 && \
    colcon build \
	  --base-paths src/slam \
	  --cmake-args -DCMAKE_CXX_FLAGS=-isystem\ /usr/local/cuda/include \
	  --event-handlers console_direct+ \
	  --merge-install \
    && rm -rf ${ROS_ROOT}/src \
    && rm -rf ${ROS_ROOT}/logs \
    && rm -rf ${ROS_ROOT}/build 
    
    
#
# rtabmap - https://github.com/introlab/rtabmap_ros/tree/ros2
#
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		  libpcl-dev \
		  libpython3-dev \
		  python3-dev \
		  libsuitesparse-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# install recommended dependencies - https://github.com/introlab/rtabmap/wiki/Installation#dependencies 
# note:  disable g2o when using orbslam, because orbslam has its own g2o
#RUN git clone https://github.com/RainerKuemmerle/g2o /tmp/g2o && \
#    cd /tmp/g2o && \
#    mkdir build && \
#    cd build && \
#    cmake -DBUILD_WITH_MARCH_NATIVE=OFF -DG2O_BUILD_APPS=OFF -DG2O_BUILD_EXAMPLES=OFF -DG2O_USE_OPENGL=OFF .. && \
#    make -j$(nproc) && \
#    make install && \
#    rm -rf /tmp/g2o
    
RUN git clone https://github.com/borglab/gtsam /tmp/gtsam && \
    cd /tmp/gtsam && \
    mkdir build && \
    cd build && \
    cmake -DGTSAM_BUILD_WITH_MARCH_NATIVE=OFF -DGTSAM_WITH_TBB=OFF .. && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/gtsam
    
RUN git clone https://github.com/ethz-asl/libnabo /tmp/libnabo && \
    cd /tmp/libnabo && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/libnabo
    
RUN git clone https://github.com/ethz-asl/libpointmatcher /tmp/libpointmatcher && \
    cd /tmp/libpointmatcher && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/libpointmatcher

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
	libyaml-cpp-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# build rtabmap / rtabmap_ros
RUN git clone https://github.com/introlab/rtabmap.git /opt/rtabmap && \
    cd /opt/rtabmap/build && \
    cmake -DWITH_PYTHON=ON -DWITH_TORCH=ON -DTorch_DIR=${PYTORCH_PATH}/share/cmake/Torch .. && \
    make -j$(nproc) && \
    make install

# since rtabmap_ros is an 'unreleased' package for ros2, manually pull it's dependencies from
# https://github.com/introlab/rtabmap_ros/blob/dfdbe1f68314e851e017c8af3788b17518a5000b/package.xml#L24
RUN source ${ROS_ENVIRONMENT} && \
    export ROS_PACKAGE_PATH=${AMENT_PREFIX_PATH} && \
    cd ${ROS_ROOT} && \
    mkdir -p src/slam && \
    
    # download sources for dependency packages
    rosinstall_generator --deps --exclude RPP --rosdistro ${ROS_DISTRO} \
          octomap \
		nav2_common \
		laser_geometry \
		pcl_conversions \
		rviz_common \
		rviz_rendering \
		rviz_default_plugins \
		realsense2_camera \
		realsense2_description \
		diagnostic_updater \
		compressed_image_transport \
		compressed_depth_image_transport \
	> ros2.${ROS_DISTRO}.rtabmap.rosinstall && \
    cat ros2.${ROS_DISTRO}.rtabmap.rosinstall && \
    vcs import src/slam < ros2.${ROS_DISTRO}.rtabmap.rosinstall && \
    
    # install apt/deb dependencies using rosdep
    apt-get update && \
    rosdep install -y \
       --ignore-src \
       --from-paths src/slam \
	  --rosdistro ${ROS_DISTRO} \
	  --skip-keys "rtabmap find_object_2d Pangolin libopencv-dev libopencv-contrib-dev libopencv-imgproc-dev python-opencv python3-opencv" && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    
    # build the dependency packages
    colcon build --merge-install --base-paths src/slam && \
	  
    # clean-up build files
    rm -rf ${ROS_ROOT}/src && \
    rm -rf ${ROS_ROOT}/logs && \
    rm -rf ${ROS_ROOT}/build && \
    rm ${ROS_ROOT}/*.rosinstall
    
# build rtabmap_ros, but first patch it to import tf2_geometry_msgs correctly
RUN source ${ROS_ENVIRONMENT} && \
    cd ${ROS_ROOT} && \
    mkdir -p src/slam && \
    
    # download and patch source
    git clone --branch ros2 https://github.com/introlab/rtabmap_ros.git src/slam/rtabmap_ros && \
    sed -i '/find_package(tf2_ros REQUIRED)/a find_package(tf2_geometry_msgs REQUIRED)' src/slam/rtabmap_ros/CMakeLists.txt && \
    sed -i '/   tf2_ros/a tf2_geometry_msgs' src/slam/rtabmap_ros/CMakeLists.txt && \
    
    # install apt/deb dependencies using rosdep
    apt-get update && \
    rosdep install -y \
    	  --ignore-src \
       --from-paths src/slam \
	  --rosdistro ${ROS_DISTRO} \
	  --skip-keys "rtabmap find_object_2d Pangolin libopencv-dev libopencv-contrib-dev libopencv-imgproc-dev python-opencv python3-opencv" && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    
    # build the node
    colcon build \
       --merge-install \
	  --base-paths src/slam/rtabmap_ros \
	  --event-handlers console_direct+ && \

    # clean-up build files
    rm -rf ${ROS_ROOT}/src && \
    rm -rf ${ROS_ROOT}/logs && \
    rm -rf ${ROS_ROOT}/build 
	  

#
# ZED SDK / zed-ros2-wrapper
# https://github.com/stereolabs/zed-docker/blob/master/3.X/jetpack_4.X/devel/Dockerfile
#
ARG ZED_SDK_URL="https://download.stereolabs.com/zedsdk/3.5/jp45/jetsons"
ARG ZED_SDK_RUN="ZED_SDK_Linux_JP.run"

RUN cd /tmp && \
    wget --quiet --show-progress --progress=bar:force:noscroll --no-check-certificate ${ZED_SDK_URL} -O ${ZED_SDK_RUN} && \
    chmod +x ${ZED_SDK_RUN} && \
    ./${ZED_SDK_RUN} silent skip_tools && \
    rm -rf /usr/local/zed/resources/* && \
    rm -rf ${ZED_SDK_RUN} && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean
    
RUN source ${ROS_ENVIRONMENT} && \
    cd ${ROS_ROOT} && \
    mkdir -p src/slam && \
    git clone https://github.com/stereolabs/zed-ros2-wrapper src/slam/zed-ros2-wrapper && \
    
    # install apt/deb dependencies using rosdep
    apt-get update && \
    rosdep install -y \
    	  --ignore-src \
       --from-paths src/slam \
	  --rosdistro ${ROS_DISTRO} \
	  --skip-keys "rtabmap find_object_2d Pangolin libopencv-dev libopencv-contrib-dev libopencv-imgproc-dev python-opencv python3-opencv" && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    
    # build the node
    colcon build \
       --merge-install \
	  --base-paths src/slam/zed-ros2-wrapper \
	  --cmake-args=-DCMAKE_BUILD_TYPE=Release && \
	  
    # clean-up build files