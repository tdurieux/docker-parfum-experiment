FROM lmark1/uav_ros_simulation:bionic

ARG HOME=/root
ARG CATKIN_WORKSPACE=uav_ws
ARG USER=root

# Step 1: Install all the needed software packages here
RUN apt-get update && apt-get install --no-install-recommends -q -y \
    vim && rm -rf /var/lib/apt/lists/*;

# Step 2: Go to the Catkin workspace and clone all needed ROS packages
WORKDIR $HOME/$CATKIN_WORKSPACE/src
RUN git clone https://github.com/larics/larics_gazebo_worlds.git
RUN git clone --branch melodic_electromagnet_dev https://github.com/larics/storm_gazebo_ros_magnet.git

# Step 3: Create the icuas22_competition package and copy its contents
WORKDIR $HOME/$CATKIN_WORKSPACE/src/icuas22_competition
COPY . .

# Step 4: Build the Catkin workspace
RUN catkin build --limit-status-rate 0.2