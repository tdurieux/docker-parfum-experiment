FROM autoware:base
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

## Copy autoware.proj.repos to the workspace
COPY autoware.proj.repos /autoware/autoware.proj.repos
WORKDIR /autoware

## Build
# hadolint ignore=DL3003,SC1091
RUN --mount=type=ssh \
  mkdir src \
  && vcs import src < autoware.proj.repos \
  && source /opt/ros/galactic/setup.bash \
  && colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release

## Change permission for runtime data conversion
RUN find /autoware/install -type d -exec chmod 777 {} \;

## Create entrypoint
COPY docker/pre-built/entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["/bin/bash"]
