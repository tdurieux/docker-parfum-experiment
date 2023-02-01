FROM ros:noetic
COPY entrypoint.sh /entrypoint.sh

RUN apt-get update && apt-get install --no-install-recommends -y \
    ros-noetic-rosdoc-lite \
    graphviz && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/entrypoint.sh"]
