FROM nvidia/cuda:8.0-devel-ubuntu14.04
MAINTAINER Yuki Iida <aiueo.0409@gmail.com>

RUN apt-get update && apt-get install -y \
        software-properties-common \
        wget curl git cmake cmake-curses-gui

# Install ROS
RUN wget http://packages.ros.org/ros.key -O - | apt-key add -
RUN echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list
RUN apt-get update && apt-get install -y ros-indigo-desktop-full ros-indigo-nmea-msgs ros-indigo-nmea-navsat-driver ros-indigo-sound-play ros-indigo-jsk-visualization ros-indigo-grid-map ros-indigo-gps-common
RUN apt-get update && apt-get install -y ros-indigo-controller-manager ros-indigo-ros-control ros-indigo-ros-controllers ros-indigo-gazebo-ros-control ros-indigo-sicktoolbox ros-indigo-sicktoolbox-wrapper ros-indigo-joystick-drivers ros-indigo-novatel-span-driver
RUN apt-get update && apt-get install -y libnlopt-dev freeglut3-dev qtbase5-dev libqt5opengl5-dev libssh2-1-dev libarmadillo-dev libpcap-dev gksu libgl1-mesa-dev libglew-dev software-properties-common libyaml-cpp-dev python-flask python-requests
RUN add-apt-repository ppa:mosquitto-dev/mosquitto-ppa
RUN apt-get update && apt-get install -y libmosquitto-dev

RUN rosdep init \
        && rosdep update \
        && echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc

# Develop
RUN apt-get install -y \
        libboost-all-dev \
        libflann-dev \
        libgsl0-dev \
        libgoogle-perftools-dev \
        libeigen3-dev

# Install some basic GUI and sound libs
RUN apt-get install -y \
        xz-utils file locales dbus-x11 pulseaudio dmz-cursor-theme \
        fonts-dejavu fonts-liberation hicolor-icon-theme \
        libcanberra-gtk3-0 libcanberra-gtk-module libcanberra-gtk3-module \
        libasound2 libgtk2.0-0 libdbus-glib-1-2 libxt6 libexif12 \
        libgl1-mesa-glx libgl1-mesa-dri \
        && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX

# Install some basic GUI tools
RUN apt-get install -y \
        cmake-qt-gui \
        gnome-terminal

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
RUN echo "source /opt/ros/indigo/setup.bash" >> /home/$USERNAME/.bashrc && \
        #Fix for qt and X server errors
        echo "export QT_X11_NO_MITSHM=1" >> /home/$USERNAME/.bashrc && \
        # cd to home on login
        echo "cd" >> /home/$USERNAME/.bashrc

############
##PT GREY FlyCaptureSDK
############
#download driver
RUN wget http://ertl.jp/~amonrroy/flycapture2-2.6.3.4-amd64-pkg.tgz && \
    tar -xvzf flycapture2-2.6.3.4-amd64-pkg.tgz
##install dependencies
RUN apt-get install -y libraw1394-11 libgtk2.0-0 libgtkmm-2.4-dev libglademm-2.4-dev libgtkglextmm-x11-1.2-dev libusb-1.0-0

RUN cd flycapture2-2.6.3.4-amd64 && \
    dpkg -i libflycapture-2* && \
    dpkg -i libflycapturegui-2* && \
    dpkg -i libflycapture-c-2* && \
    dpkg -i libflycapturegui-c-2* && \
    dpkg -i libmultisync-2* && \
    dpkg -i flycap-2* && \
    dpkg -i flycapture-doc-2* && \
    dpkg -i updatorgui*

#setup camera usb permissions
ENV PGUDEVFILE /etc/udev/rules.d/40-pgr.rules
RUN groupadd -f pgrimaging && \
    usermod -a -G pgrimaging $USERNAME && \
    echo "SUBSYSTEM==\"usb\", ATTR{idVendor}==\"1e10\", MODE=\"0666\", GROUP=\"pgrimaging\" " >> PGUDEVFILE && \
/etc/init.d/udev restart

## End PT GREY

# Change user
USER autoware

# YOLO_V2
RUN cd && git clone https://github.com/pjreddie/darknet.git
RUN cd ~/darknet && git checkout 56d69e73aba37283ea7b9726b81afd2f79cd1134
RUN cd ~/darknet/data && wget https://pjreddie.com/media/files/yolo.weights

# Install Autoware
RUN cd && mkdir /home/$USERNAME/Autoware
COPY --chown=autoware ./ /home/$USERNAME/Autoware/
RUN git clone https://github.com/CPFL/Autoware.git /home/$USERNAME/Autoware
RUN /bin/bash -c 'source /opt/ros/indigo/setup.bash; cd /home/$USERNAME/Autoware/ros/src; git submodule update --init --recursive; catkin_init_workspace; cd ../; ./catkin_make_release'
RUN echo "source /home/$USERNAME/Autoware/ros/devel/setup.bash" >> /home/$USERNAME/.bashrc

# Change Terminal Color
RUN gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_background" --type bool false
RUN gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_colors" --type bool false
RUN gconftool-2 --set "/apps/gnome-terminal/profiles/Default/background_color" --type string "#FFFFFF"

# Default CMD
CMD ["/bin/bash"]
