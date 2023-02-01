########################################################
# Based on Ubuntu 18.04
########################################################

# Set the base image to ubuntu 18.04

FROM ubuntu:bionic

MAINTAINER Liu Cong "congx.liu@intel.com"

ARG DEPS_DIR=/root/deps
WORKDIR $DEPS_DIR

# install ros2 grasp library deps