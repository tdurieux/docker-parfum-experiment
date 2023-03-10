FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive

RUN echo ::group::Container setup

RUN apt-get update \
 && apt-get install --no-install-recommends -y \
      sudo tzdata \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;

ARG GZ_VERSION_PASSWORD
ARG GZ_VERSION_DATE

COPY s3.cfg /root/.s3cfg

COPY scripts/install_common_deps.sh scripts/install_common_deps.sh
RUN scripts/install_common_deps.sh

COPY scripts/enable_gcc8.sh scripts/enable_gcc8.sh
RUN scripts/enable_gcc8.sh

COPY scripts/build_gz.sh scripts/build_gz.sh

RUN echo ::endgroup::

# See https://github.com/gazebosim/docs/issues/53
# RUN scripts/build_gz.sh gazebosim gz-cmake ign-cmake2 n \
#       $GZ_VERSION_DATE \
#       $GZ_VERSION_PASSWORD; exit 0

RUN scripts/build_gz.sh gazebosim gz-math ign-math6 y \
      $GZ_VERSION_DATE \
      $GZ_VERSION_PASSWORD; exit 0

# See https://github.com/gazebosim/docs/issues/53
# RUN scripts/build_gz.sh gazebosim gz-tools ign-tools1 n \
#       $GZ_VERSION_DATE \
#       $GZ_VERSION_PASSWORD; exit 0

RUN scripts/build_gz.sh gazebosim gz-plugin ign-plugin1 y \
      $GZ_VERSION_DATE \
      $GZ_VERSION_PASSWORD; exit 0

RUN scripts/build_gz.sh gazebosim gz-common ign-common3 y \
      $GZ_VERSION_DATE \
      $GZ_VERSION_PASSWORD; exit 0

# SDFormat's documentation is uploaded in a different way
# Keeping it here for completeness
# RUN scripts/build_gz.sh osrf sdformat sdf9 n \
#       $GZ_VERSION_DATE \
#       $GZ_VERSION_PASSWORD; exit 0

RUN scripts/build_gz.sh gazebosim gz-msgs ign-msgs5 y \
      $GZ_VERSION_DATE \
      $GZ_VERSION_PASSWORD; exit 0

RUN scripts/build_gz.sh gazebosim gz-transport ign-transport8 y \
      $GZ_VERSION_DATE \
      $GZ_VERSION_PASSWORD; exit 0

RUN scripts/build_gz.sh gazebosim gz-fuel-tools ign-fuel-tools4 y \
      $GZ_VERSION_DATE \
      $GZ_VERSION_PASSWORD; exit 0

RUN scripts/build_gz.sh gazebosim gz-rendering ign-rendering3 y \
      $GZ_VERSION_DATE \
      $GZ_VERSION_PASSWORD; exit 0

RUN scripts/build_gz.sh gazebosim gz-sensors ign-sensors3 y \
      $GZ_VERSION_DATE \
      $GZ_VERSION_PASSWORD; exit 0

RUN scripts/build_gz.sh gazebosim gz-gui ign-gui3 y \
      $GZ_VERSION_DATE \
      $GZ_VERSION_PASSWORD; exit 0

RUN scripts/build_gz.sh gazebosim gz-physics ign-physics2 y \
      $GZ_VERSION_DATE \
      $GZ_VERSION_PASSWORD; exit 0

RUN scripts/build_gz.sh gazebosim gz-sim ign-gazebo3 y \
      $GZ_VERSION_DATE \
      $GZ_VERSION_PASSWORD; exit 0

RUN scripts/build_gz.sh gazebosim gz-launch ign-launch2 y \
      $GZ_VERSION_DATE \
      $GZ_VERSION_PASSWORD; exit 0
