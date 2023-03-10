# ROSPlan_demos docker image
FROM kclplanning/rosplan

SHELL ["/bin/bash", "-c"]
WORKDIR /root/ws

# Clone ROSPlan demos 
RUN git clone --depth 1 https://github.com/KCL-Planning/rosplan_demos.git src/rosplan_demos

# Get dependencies
RUN git clone --depth 1 https://github.com/clearpathrobotics/occupancy_grid_utils.git src/occupancy_grid_utils


# Further dependencies
RUN source devel/setup.bash &&\
    rosdep update &&\
    rosdep install --from-paths src/occupancy_grid_utils src/rosplan_demos/rosplan_demos_interfaces --ignore-src -q -r -y

# Build workspace