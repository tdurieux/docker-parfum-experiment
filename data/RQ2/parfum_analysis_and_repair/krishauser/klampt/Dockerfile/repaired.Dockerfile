FROM ubuntu:20.04

# This image contains Klamp't: Kris' Locomotion and Manipulation Planning Toolbox
# This image utilizes X11 in order to allow users to interact with the GUI.
# This image requires root access to run.

MAINTAINER Steve Kuznetsov <skuznets@redhat.com>

# Install dependencies
RUN apt-get update

RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install freeglut3-dev qt5-default && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install python3-dev python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir PyOpenGL PyQt5 Klampt
