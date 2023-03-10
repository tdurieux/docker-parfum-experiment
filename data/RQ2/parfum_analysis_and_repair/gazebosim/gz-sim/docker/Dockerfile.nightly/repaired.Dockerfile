FROM ign-gazebo:base

COPY docker/scripts/enable_ign_stable.sh scripts/enable_ign_stable.sh
RUN scripts/enable_ign_stable.sh

COPY docker/scripts/enable_ign_prerelease.sh scripts/enable_ign_prerelease.sh
RUN scripts/enable_ign_prerelease.sh

COPY docker/scripts/enable_ign_nightly.sh scripts/enable_ign_nightly.sh
RUN scripts/enable_ign_nightly.sh

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
    libignition-cmake2-dev \
    libignition-common4-dev \
    libignition-fuel-tools7-dev \
    libignition-math6-eigen3-dev \
    libignition-plugin-dev \
    libignition-physics5-dev \
    libignition-rendering6-dev \
    libignition-tools-dev \
    libignition-transport11-dev \
    libignition-gui6-dev \
    libignition-msgs8-dev \
    libignition-sensors6-dev \
    libsdformat12-dev && rm -rf /var/lib/apt/lists/*;

COPY . ign-gazebo
RUN cd ign-gazebo \
 && ./docker/scripts/build_ign_gazebo.sh

COPY ./docker/scripts/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
