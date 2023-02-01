FROM ros:kinetic
LABEL maintainer "cagatay.odabasi@ipa.fraunhofer.de"

RUN apt-get update && apt-get install --no-install-recommends -y libopencv-dev \
    ros-kinetic-astra-camera \
    ros-kinetic-astra-launch && rm -rf /var/lib/apt/lists/*;

RUN  echo   " ===========  Build Complete  =========   "

