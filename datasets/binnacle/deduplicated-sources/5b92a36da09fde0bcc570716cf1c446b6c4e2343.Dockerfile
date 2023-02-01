FROM nvidia/cuda:8.0-devel-ubuntu16.04


# Develop
RUN apt-get update && apt-get install -y \
        software-properties-common \
        wget curl git cmake cmake-curses-gui \
        libboost-all-dev \
        libflann-dev \
        libgsl0-dev \
        libgoogle-perftools-dev \
        libeigen3-dev \
	ca-certificates \
	make \
	autoconf \
	libtool \
	pkg-config \
	python \
	libxext-dev \
	x11proto-gl-dev &&\
	rm -rf /var/lib/apt/lists/*
 
RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y --no-install-recommends \
        gcc-multilib \
        libxext-dev:i386 \
        libx11-dev:i386 && \
    rm -rf /var/lib/apt/lists/*

# Intall some basic GUI and sound libs
RUN apt-get update && apt-get install -y \
        xz-utils file locales dbus-x11 pulseaudio dmz-cursor-theme \
        fonts-dejavu fonts-liberation hicolor-icon-theme \
        libcanberra-gtk3-0 libcanberra-gtk-module libcanberra-gtk3-module \
        libasound2 libgtk2.0-0 libdbus-glib-1-2 libxt6 libexif12 \
        libgl1-mesa-glx libgl1-mesa-dri language-pack-en \
        && update-locale LANG=en_US.UTF-8 LC_MESSAGES=POSIX

# Intall some basic GUI tools
RUN apt-get update && apt-get install -y \
        cmake-qt-gui \
        gnome-terminal

# Intall ROS
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN apt-get update && apt-get install -y ros-kinetic-desktop-full ros-kinetic-nmea-msgs ros-kinetic-nmea-navsat-driver ros-kinetic-sound-play ros-kinetic-jsk-visualization ros-kinetic-grid-map ros-kinetic-gps-common
RUN apt-get update && apt-get install -y ros-kinetic-controller-manager ros-kinetic-ros-control ros-kinetic-ros-controllers ros-kinetic-gazebo-ros-control ros-kinetic-joystick-drivers ros-kinetic-rosbridge-server
RUN apt-get update && apt-get install -y libnlopt-dev freeglut3-dev qtbase5-dev libqt5opengl5-dev libssh2-1-dev libarmadillo-dev libpcap-dev gksu libgl1-mesa-dev libglew-dev python-wxgtk3.0 software-properties-common libmosquitto-dev libyaml-cpp-dev python-flask python-requests

# Add basic user
ENV USERNAME autoware
ENV PULSE_SERVER /run/pulse/native
RUN useradd -m $USERNAME && \
        echo "$USERNAME:$USERNAME" | chpasswd && \
        usermod --shell /bin/bash $USERNAME && \
        usermod -aG sudo $USERNAME && \
        echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
        chmod 0440 /etc/sudoers.d/$USERNAME && \
        # Replace 1000 with your user/group id
        usermod  --uid 1000 $USERNAME && \
        groupmod --gid 1000 $USERNAME

# Setup .bashrc for ROS
RUN echo "source /opt/ros/kinetic/setup.bash" >> /home/$USERNAME/.bashrc && \
        #Fix for qt and X server errors
        echo "export QT_X11_NO_MITSHM=1" >> /home/$USERNAME/.bashrc && \
        # cd to home on login
        echo "cd" >> /home/$USERNAME/.bashrc

# ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},graphics

RUN apt-get update && apt-get install -y --no-install-recommends \
        pkg-config \
        libxau-dev \
        libxdmcp-dev \
        libxcb1-dev \
        libxext-dev \
        libx11-dev && \
    rm -rf /var/lib/apt/lists/*

COPY --from=nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04 \
  /usr/local/lib/x86_64-linux-gnu \
  /usr/local/lib/x86_64-linux-gnu

COPY --from=nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04 \
  /usr/local/share/glvnd/egl_vendor.d/10_nvidia.json \
  /usr/local/share/glvnd/egl_vendor.d/10_nvidia.json

RUN echo '/usr/local/lib/x86_64-linux-gnu' >> /etc/ld.so.conf.d/glvnd.conf && \
    ldconfig && \
    echo '/usr/local/$LIB/libGL.so.1' >> /etc/ld.so.preload && \
    echo '/usr/local/$LIB/libEGL.so.1' >> /etc/ld.so.preload

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# Change user
USER autoware

RUN sudo rosdep init \
        && rosdep update \
        && echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc

# YOLO_V2 and YOLO_V3
RUN cd ~ && git clone https://github.com/pjreddie/darknet.git darknet \
    && cd ~/darknet && git checkout 56d69e73aba37283ea7b9726b81afd2f79cd1134

COPY --chown=autoware:autoware ./docker/generic/data/yolov2/yolo.cfg /home/$USERNAME/darknet/cfg/yolo.cfg
COPY --chown=autoware:autoware ./docker/generic/data/yolov2/yolo.weights /home/$USERNAME/darknet/data/yolo.weights
COPY --chown=autoware:autoware ./docker/generic/data/yolov3/yolov3.cfg /home/$USERNAME/darknet/cfg/yolov3.cfg
COPY --chown=autoware:autoware ./docker/generic/data/yolov3/yolov3.weights /home/$USERNAME/darknet/data/yolov3.weights


# SSD dependencies
RUN sudo apt-get update && sudo apt-get install -y libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y libboost-all-dev
RUN sudo apt-get update && sudo apt-get install -y libatlas-base-dev libgoogle-glog-dev libgflags-dev liblmdb-dev
RUN sudo apt-get update && sudo apt-get install -y libhdf5-10 libhdf5-serial-dev libhdf5-dev libhdf5-cpp-11

# SSD setup
RUN cd ~ && git clone https://github.com/weiliu89/caffe.git ssdcaffe \
    && cd ~/ssdcaffe && git checkout 4817bf8b4200b35ada8ed0dc378dceaf38c539e4

COPY --chown=autoware:autoware ./docker/generic/data/ssd/Makefile.config /home/$USERNAME/ssdcaffe/Makefile.config
COPY --chown=autoware:autoware ./docker/generic/data/ssd/models/ /home/$USERNAME/ssdcaffe/models/

RUN cd ~/ssdcaffe && make && make distribute


# Install Autoware
COPY . /home/$USERNAME/autoware
RUN sudo chown -R autoware /home/$USERNAME/autoware
RUN /bin/bash -c 'source /opt/ros/kinetic/setup.bash; cd /home/$USERNAME/autoware/ros/src; git submodule update --init --recursive; catkin_init_workspace; cd ../; ./catkin_make_release'
RUN echo "source /home/$USERNAME/autoware/ros/devel/setup.bash" >> /home/$USERNAME/.bashrc

# Setting
ENV LANG="en_US.UTF-8"
RUN echo "export LANG=\"en_US.UTF-8\"" >> /home/$USERNAME/.bashrc

# Install dev tools
RUN sudo apt-get -y install vim tmux

# Change Terminal Color
RUN gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_background" --type bool false
RUN gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_colors" --type bool false
RUN gconftool-2 --set "/apps/gnome-terminal/profiles/Default/background_color" --type string "#000000"


# Default CMD
CMD ["/bin/bash"]
