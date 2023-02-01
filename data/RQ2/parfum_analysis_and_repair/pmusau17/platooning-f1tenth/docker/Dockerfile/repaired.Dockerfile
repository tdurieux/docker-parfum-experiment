FROM nvidia/cudagl:11.4.0-base-ubuntu20.04
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},display
ENV DEBIAN_FRONTEND=noninteractive

#install ros
RUN apt-get update && apt-get install --no-install-recommends -q -y \
    dirmngr \
    gnupg2 \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Setup your computer to accept software from packages.ros.org
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -f https://repo.ros2.org/repos.key | apt-key add -

## Set up keys
RUN curl -f -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && apt-get update

RUN apt install --no-install-recommends -y ros-noetic-desktop-full && apt -y --no-install-recommends install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential && rm -rf /var/lib/apt/lists/*;

RUN rosdep init && rosdep update

#install pip
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

# RUN pip install rospkg defusedxml PySide2
# RUN pip install empy

#Need these packages for debugging
RUN apt-get install --no-install-recommends -y nano && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y net-tools && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends python-is-python3 && pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir imutils numpy scipy rdp do-mpc && pip install --no-cache-dir tensorflow-gpu==2.2 && pip install --no-cache-dir pathlib && rm -rf /var/lib/apt/lists/*;

#navigate to the home directory
WORKDIR home
RUN pip install --no-cache-dir gdown
RUN gdown https://drive.google.com/uc?id=152KL7JzDReYdg6quBznL9WtC0I5IvNx6
RUN apt-get install -y --no-install-recommends unzip && unzip rl_library.zip && rm -rf /var/lib/apt/lists/*;
WORKDIR rl_library
RUN pip install --no-cache-dir -e .
WORKDIR ..


RUN git clone https://github.com/pmusau17/Platooning-F1Tenth
WORKDIR Platooning-F1Tenth

RUN git pull && apt-get update && rosdep install --from-paths src --ignore-src -r -y --rosdistro noetic
RUN /bin/bash -c "apt install -y python3-colcon-common-extensions ros-noetic-ackermann-msgs && source /opt/ros/noetic/setup.bash &&  colcon build"