FROM ros:noetic-ros-core

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential python3-rosdep python3-catkin-lint python3-catkin-tools \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install pre-commit hooks to /root/.cache/pre-commit/
RUN apt-get update -qq \
    && apt-get install -y -qq --no-install-recommends git python3-pip ruby shellcheck clang-format-10 python3-catkin-lint \
    && rm -rf /var/lib/apt/lists/*
RUN pip3 install --no-cache-dir pre-commit
RUN mkdir -p /tmp/pre-commit
COPY .pre-commit-config.yaml /tmp/pre-commit/
RUN cd /tmp/pre-commit \
    && git init \
    && pre-commit install-hooks \
    && rm -rf /tmp/pre-commit

# Create ROS workspace
COPY . /ws/src/mir_robot
WORKDIR /ws

# Use rosdep to install all dependencies (including ROS itself)
RUN rosdep init \
    && rosdep update \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive rosdep install --from-paths src -i -y --rosdistro noetic \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && \
    catkin init && \
    catkin config --install -j 1 -p 1 && \
    catkin build --limit-status-rate 0.1 --no-notify && \
    catkin build --limit-status-rate 0.1 --no-notify --make-args tests"
