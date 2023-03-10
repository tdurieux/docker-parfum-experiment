# Docker file for RoboCup@HomeEducation
# ROS Kinetic, navigation, perception & additional packages
# Version 1.0.2 - 9/8/2020

FROM rchomeedu-1604-kinetic:base

ARG MACHTYPE=default

###### User robot ######

USER robot

# Libraries

# g2o

RUN mkdir -p $HOME/lib && cd $HOME/lib && \
    wget https://www.diag.uniroma1.it/iocchi/marrtino/lib/g2o-marrtino-src.tgz && \
    tar xzf g2o-marrtino-src.tgz && \
    rm g2o-marrtino-src.tgz && \
    cd g2o && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make

RUN echo "" >> $HOME/.bashrc && \
    echo "export G2O_ROOT=\$HOME/lib/g2o" >> $HOME/.bashrc && \
    echo "export G2O_BIN=\$HOME/lib/g2o/bin" >> $HOME/.bashrc && \
    echo "export G2O_LIB=\$HOME/lib/g2o/lib" >> $HOME/.bashrc && \
    echo "export LD_LIBRARY_PATH=\$HOME/lib/g2o/lib:\${LD_LIBRARY_PATH}" >> $HOME/.bashrc && \
    echo "" >> $HOME/.bashrc


# Get additional packages

RUN mkdir -p $HOME/src &&  cd $HOME/src && \
    git clone https://bitbucket.org/iocchi/stage_environments.git && \
    git clone https://github.com/Imperoli/gradient_based_navigation.git && \
    git clone https://bitbucket.org/ggrisetti/thin_drivers.git && \
    git clone https://bitbucket.org/mtlazaro/modim.git

RUN mkdir -p $HOME/src/ros &&  cd $HOME/src/ros && \
    git clone https://github.com/seqsense/usb_cam.git  && \  
    git clone https://github.com/orbbec/ros_astra_camera.git && \
    git clone https://github.com/orbbec/ros_astra_launch.git && \
    git clone https://github.com/ros-drivers/urg_c.git && \
    git clone https://github.com/ros-drivers/urg_node.git && \
    git clone https://github.com/Slamtec/rplidar_ros.git && \
    git clone https://github.com/ros-perception/laser_proc.git  && \
    git clone https://github.com/RIVeR-Lab/apriltags_ros.git
#   git clone https://bitbucket.org/iocchi/apriltags_ros.git NOT WORKING


# MARRtino ROS node

RUN mkdir -p $HOME/src/srrg && cd $HOME/src/srrg && \
    git clone https://gitlab.com/srrg-software/srrg_cmake_modules.git && \
    git clone https://gitlab.com/srrg-software/srrg2_orazio.git

# srrg_mapper

RUN mkdir -p $HOME/src/srrg && cd $HOME/src/srrg && \
    git clone https://gitlab.com/srrg-software/srrg_core.git && \
    cd srrg_core && git checkout a8f88898 && cd .. && \
    git clone https://gitlab.com/srrg-software/srrg_scan_matcher.git && \
    cd srrg_scan_matcher && git checkout 31e7c7ac && cd .. && \
    git clone https://gitlab.com/srrg-software/srrg_mapper2d.git && \
    cd srrg_mapper2d && git checkout 5ea162d1 && cd .. && \
    git clone https://gitlab.com/srrg-software/srrg_mapper2d_ros.git && \
    cd srrg_mapper2d_ros && git checkout 9aa14795 && cd ..


# patches

RUN cd $HOME/src/srrg/srrg_mapper2d_ros && \
    rm CMakeLists.txt package.xml && \
    wget https://www.diag.uniroma1.it/iocchi/marrtino/patches/srrg_mapper2d_ros/CMakeLists.txt && \
    wget https://www.diag.uniroma1.it/iocchi/marrtino/patches/srrg_mapper2d_ros/package.xml && \
    cd $HOME/src/srrg/srrg_mapper2d_ros/src && \
    rm srrg_mapper2d_node.cpp message_handler.cpp && \
    wget https://www.diag.uniroma1.it/iocchi/marrtino/patches/srrg_mapper2d_ros/srrg_mapper2d_node.cpp && \
    wget https://www.diag.uniroma1.it/iocchi/marrtino/patches/srrg_mapper2d_ros/message_handler.cpp && \
    cd $HOME/src/srrg/srrg_scan_matcher/src && \
    rm laser_message_tracker.cpp && \
    wget https://www.diag.uniroma1.it/iocchi/marrtino/patches/srrg_scan_matcher/laser_message_tracker.cpp


# Set up .bashrc

RUN echo "export MARRTINO_APPS_HOME=$HOME/src/marrtino_apps" >> $HOME/.bashrc
RUN echo "export ROBOT_TYPE=stage" >> $HOME/.bashrc
RUN echo "if [ -d /usr/lib/nvidia-384/ ]; then" >> $HOME/.bashrc
RUN echo "  export PATH=\"/usr/lib/nvidia-384/bin:\${PATH}\"" >> $HOME/.bashrc
RUN echo "  export LD_LIBRARY_PATH=\"/usr/lib/nvidia-384:/usr/lib32/nvidia-384:\${LD_LIBRARY_PATH}\" " >> $HOME/.bashrc
RUN echo "fi" >> $HOME/.bashrc


# Set and compile ROS packages

RUN cd $HOME/ros/catkin_ws/src && \
    ln -s $HOME/src/ros/usb_cam . && \
    ln -s $HOME/src/ros/ros_astra_camera . && \
    ln -s $HOME/src/ros/ros_astra_launch . && \
    ln -s $HOME/src/ros/apriltags_ros . && \
    ln -s $HOME/src/ros/urg_c . && \
    ln -s $HOME/src/ros/urg_node . && \
    ln -s $HOME/src/ros/rplidar_ros . && \
    ln -s $HOME/src/ros/laser_proc .  && \
    ln -s $HOME/src/stage_environments . && \
    ln -s $HOME/src/gradient_based_navigation . && \
    ln -s $HOME/src/srrg/srrg_cmake_modules . && \
    ln -s $HOME/src/srrg/srrg2_orazio . && \
    ln -s $HOME/src/thin_drivers/thin_msgs . && \
    ln -s $HOME/src/thin_drivers/thin_state_publisher . && \
    ln -s $HOME/src/srrg/srrg_core . && \
    ln -s $HOME/src/srrg/srrg_scan_matcher . && \
    ln -s $HOME/src/srrg/srrg_mapper2d . && \
    ln -s $HOME/src/srrg/srrg_mapper2d_ros .

RUN echo "export MARRTINO_VERSION=\"docker\"" >> $HOME/.bashrc
RUN echo "docker" >> $HOME/.marrtino_version

RUN if [ "$MACHTYPE" = "aarch64" ]; then \
       /bin/bash -ci "cd $HOME/ros/catkin_ws; catkin_make -j2" ; \
    elif [ "$MACHTYPE" = "armv7l" ]; then \
       /bin/bash -ci "cd $HOME/ros/catkin_ws; catkin_make -j1" ; \
    else \
       /bin/bash -ci "cd $HOME/ros/catkin_ws; catkin_make" ; \
    fi

# marrtino_apps

RUN cd $HOME/src && git clone https://bitbucket.org/iocchi/marrtino_apps.git

# rc-home-edu-learn-ros

RUN cd $HOME/src && git clone https://github.com/robocupathomeedu/rc-home-edu-learn-ros.git


# Configure web server

USER root

RUN /bin/bash -ci "cd /var/www; mv html html.2; ln -s /home/robot/src/marrtino_apps/www html"

RUN echo "robot ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/robot


USER robot

# Set working dir and container command

WORKDIR /home/robot

CMD [ "/bin/bash", "-ci", "/home/robot/src/marrtino_apps/bringup/1-bringup.bash", "-docker" ]

#CMD /usr/bin/tmux

