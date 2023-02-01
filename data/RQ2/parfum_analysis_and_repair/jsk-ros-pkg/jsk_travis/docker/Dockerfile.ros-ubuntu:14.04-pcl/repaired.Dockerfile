INCLUDE+ Dockerfile.ros-ubuntu:14.04

RUN sudo apt-get update && \
    sudo apt-get install --no-install-recommends -y python-vtk tcl-vtk && \
    sudo rm -rf /var/lib/apt/lists/*
RUN sudo apt-get update && \
    sudo apt-get install --no-install-recommends -y ros-indigo-pcl-conversions ros-indigo-pcl-ros ros-indigo-octomap-server && \
    sudo rm -rf /var/lib/apt/lists/*
RUN sudo apt-get update && \
    sudo apt-get install --no-install-recommends -y ros-indigo-rviz ros-indigo-robot-self-filter ros-indigo-moveit-ros-perception && \
    sudo rm -rf /var/lib/apt/lists/*
RUN sudo apt-get update && \
    sudo apt-get install --no-install-recommends -y libopencv-dev liblapack-dev && \
    sudo rm -rf /var/lib/apt/lists/*
RUN sudo apt-get update && \
    sudo apt-get install --no-install-recommends -y emacs cython && \
    sudo rm -rf /var/lib/apt/lists/*

# image_view
RUN sudo apt-get update && \
    rosdep update --include-eol-distros && \
    rosdep resolve gtk2 | sed -e "s/^#.*//g" | xargs sudo apt-get install -y  && \
    sudo rm -rf /var/lib/apt/lists/*
# qt_gui_core
RUN sudo apt-get update && \
    rosdep update --include-eol-distros && \
    rosdep resolve python-qt-bindings | sed -e "s/^#.*//g" | xargs sudo apt-get install -y && \
    sudo rm -rf /var/lib/apt/lists/*
# libqt5-gui
RUN sudo apt-get update && \
    rosdep update --include-eol-distros && \
    rosdep resolve libqt5-gui | sed -e "s/^#.*//g" | xargs sudo apt-get install -y && \
    sudo rm -rf /var/lib/apt/lists/*
# qt5-qmake
RUN sudo apt-get update && \
    rosdep update --include-eol-distros && \
    rosdep resolve qt5-qmake | sed -e "s/^#.*//g" | xargs sudo apt-get install -y && \
    sudo rm -rf /var/lib/apt/lists/*
# python-h5py
RUN sudo apt-get update && \
    rosdep update --include-eol-distros && \
    rosdep resolve python-h5py | sed -e "s/^#.*//g" | xargs sudo apt-get install -y && \
    sudo rm -rf /var/lib/apt/lists/*
RUN sudo apt-get update && \
    sudo apt-get install --no-install-recommends -y octave festival && \
    sudo rm -rf /var/lib/apt/lists/*

# pip installed tornado (5.1.1) fails on 14.04
RUN sudo apt-get update && \
    sudo apt-get install --no-install-recommends -y python-tornado && \
    sudo rm -rf /var/lib/apt/lists/*

# fix latest pip install fcn errors
RUN curl -f https://bootstrap.pypa.io/pip/2.7/get-pip.py | sudo python -; sudo -H pip install --no-cache-dir 'pip<10'
RUN sudo pip install --no-cache-dir fcn chainercv chainer==6.7.0 cupy-cuda91 decorator==4.4.2

# install package to speedup
RUN sudo pip install --no-cache-dir freezegun
