# Image: introlab3it/rtabmap:androidXX

FROM introlab3it/rtabmap:android-deps

ARG API_VERSION=23

WORKDIR /root/

# Copy current source code