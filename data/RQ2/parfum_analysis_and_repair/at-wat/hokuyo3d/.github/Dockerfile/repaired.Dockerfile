# This file is automatically deployed from https://github.com/at-wat/.rospkg-assets.
# Please don't directly edit; update at-wat/.rospkg-assets instead.

ARG ROS_DISTRO=noetic
# ========================================
FROM ghcr.io/alpine-ros/alpine-ros:noetic-3.14-bare as cloner

RUN apk add --no-cache git py3-wstool

WORKDIR /repos-isolated
COPY .rosinstall-isolated /repos-isolated/deps.rosinstall

RUN wstool init src --shallow deps.rosinstall

RUN mkdir -p /repos-isolated-manifests/src
RUN find . -name package.xml | xargs -ISRC cp --parents SRC /repos-isolated-manifests/

WORKDIR /repos
COPY .rosinstall /repos/deps.rosinstall

RUN wstool init src --shallow deps.rosinstall
COPY . /repos/src/self

RUN mkdir -p /repos-manifests/src
RUN find . -name package.xml | xargs -ISRC cp --parents SRC /repos-manifests/

# ========================================