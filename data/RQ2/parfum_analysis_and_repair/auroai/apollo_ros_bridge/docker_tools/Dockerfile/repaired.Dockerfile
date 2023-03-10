FROM nvidia/cuda:8.0-cudnn7-devel-ubuntu14.04

# Set TERM to suppress warning messages.
ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm


RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
    wget \
    pkg-config \
    zip \
    g++ \
    zlib1g-dev \
    unzip python \
    wget libtool \
    cmake \
    libboost-all-dev \
    git \
    libssl-dev \
    net-tools && rm -rf /var/lib/apt/lists/*;



# install bazel
RUN wget https://github.com/bazelbuild/bazel/releases/download/0.5.3/bazel-0.5.3-installer-linux-x86_64.sh -O /tmp/bazel-0.5.3-installer-linux-x86_64.sh
RUN chmod +x /tmp/bazel-0.5.3-installer-linux-x86_64.sh
RUN bash /tmp/bazel-0.5.3-installer-linux-x86_64.sh

# Run installers.
# copying fastrtps
COPY fast-rtps /usr/local/fast-rtps
COPY installers /tmp/installers
RUN bash /tmp/installers/install_google_styleguide.sh
RUN bash /tmp/installers/install_protobuf.sh
# get proto tar for bazel build to be successful
RUN wget https://github.com/google/protobuf/releases/download/v3.3.0/protobuf-cpp-3.3.0.tar.gz -O /home/tmp/protobuf-3.3.0.tar.gz


# other deps
# RUN apt-get install libcurl4-nss-dev -y
# RUN bash /tmp/installers/install_bosfs.sh
RUN apt-get install --no-install-recommends apt-utils -y \
    libjsoncpp-dev -y && rm -rf /var/lib/apt/lists/*;

# glog and gflags
RUN apt purge libgflags-dev -y && \
    apt-get install --no-install-recommends libgflags-dev -y \
    libgoogle-glog-dev \
    libpoco-dev \
    uuid-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get update
RUN apt-get install --no-install-recommends terminator -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y python curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python get-pip.py
RUN pip install --no-cache-dir pyyaml


RUN apt install --no-install-recommends base-files lsb-release lsb-base -y && rm -rf /var/lib/apt/lists/*;

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
	apt-get update && apt-get install --no-install-recommends -y \
        dpkg \
        ros-indigo-ros-comm \
        ros-indigo-common-msgs \
        ros-indigo-tf \
        python-catkin-tools && rm -rf /var/lib/apt/lists/*;

RUN sudo apt-get install --no-install-recommends libncurses5-dev libncursesw5-dev -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/apollo_ros_bridge
