# Udacity capstone project dockerfile
FROM ros:kinetic-robot
LABEL maintainer="olala7846@gmail.com"

# Install Dataspeed DBW https://goo.gl/KFSYi1 from binary
# adding Dataspeed server to apt
RUN sh -c 'echo "deb [ arch=amd64 ] http://packages.dataspeedinc.com/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-dataspeed-public.list'
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FF6D3CDA
RUN apt-get update

# setup rosdep
RUN sh -c 'echo "yaml http://packages.dataspeedinc.com/ros/ros-public-'$ROS_DISTRO'.yaml '$ROS_DISTRO'" > /etc/ros/rosdep/sources.list.d/30-dataspeed-public-'$ROS_DISTRO'.list'
RUN rosdep update
RUN apt-get install --no-install-recommends -y ros-$ROS_DISTRO-dbw-mkz && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y
# end installing Dataspeed DBW

# install python packages
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# install required ros dependencies
RUN apt-get install --no-install-recommends -y ros-$ROS_DISTRO-cv-bridge && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ros-$ROS_DISTRO-pcl-ros && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ros-$ROS_DISTRO-image-proc && rm -rf /var/lib/apt/lists/*;

# socket io
RUN apt-get install --no-install-recommends -y netbase && rm -rf /var/lib/apt/lists/*;

RUN mkdir /capstone
VOLUME ["/capstone"]
VOLUME ["/root/.ros/log/"]
WORKDIR /capstone/ros

CMD ["bash", "../entrypoint.sh"]