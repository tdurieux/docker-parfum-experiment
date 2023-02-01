FROM ubuntu:16.04
MAINTAINER Kenji Funaoka <kenji.funaoka@tier4.jp>

# Develop
RUN apt-get update && apt-get install -y \
        software-properties-common \
        wget curl git cmake cmake-curses-gui \
        libboost-all-dev \
        libflann-dev \
        libgsl0-dev \
        libgoogle-perftools-dev \
        libeigen3-dev \
	scons \
        pkg-config \
        llvm-dev \
	libgl1-mesa-dev \
        libxi-dev \
        libx11-dev \
        libxcb1-dev \
        libxrender-dev \
        zlib1g-dev \
        flex \
        bison \
        python-mako 
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
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
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

RUN cd /opt && \
    git clone -b mesa-17.0.0 https://anongit.freedesktop.org/git/mesa/mesa.git && \
    cd mesa && \
    scons build=release libgl-xlib && \
    cd .. && \
    mv mesa/build/linux-x86_64/gallium/targets/libgl-xlib ./ && \
    rm -rf mesa

# Change user
USER autoware

RUN sudo rosdep init \
        && rosdep update \
        && echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc

# YOLO_V2
RUN cd && git clone https://github.com/pjreddie/darknet.git
RUN cd ~/darknet && git checkout 56d69e73aba37283ea7b9726b81afd2f79cd1134
RUN cd ~/darknet/data && wget https://pjreddie.com/media/files/yolo.weights

# Install Autoware
RUN cd && git clone https://github.com/CPFL/Autoware.git /home/$USERNAME/Autoware
RUN /bin/bash -c 'source /opt/ros/kinetic/setup.bash; cd /home/$USERNAME/Autoware/ros/src; git submodule update --init --recursive; catkin_init_workspace; cd ../; ./catkin_make_release'
RUN echo "source /home/$USERNAME/Autoware/ros/devel/setup.bash" >> /home/$USERNAME/.bashrc

# Setting
ENV LANG="en_US.UTF-8"
RUN echo "export LANG=\"en_US.UTF-8\"" >> /home/$USERNAME/.bashrc

# Install dev tools
RUN sudo apt-get -y install vim tmux

# Change Terminal Color
RUN gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_background" --type bool false
RUN gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_colors" --type bool false
RUN gconftool-2 --set "/apps/gnome-terminal/profiles/Default/background_color" --type string "#000000"


# this will make applications to use libGL.so file from /opt/libgl-xlib folder
ENV LD_LIBRARY_PATH="/opt/libgl-xlib:$LD_LIBRARY_PATH"


# Default CMD
CMD ["/bin/bash"]




