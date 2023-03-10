FROM ubuntu:16.04
MAINTAINER Henry Lawson "henry.lawson@foinq.com"

RUN apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;

ENV REFRESHED_AT 2016-01-24
RUN sudo dpkg --add-architecture i386
RUN sudo apt-get update
RUN sudo apt-key update
RUN sudo apt-get -y --no-install-recommends install apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get -y --no-install-recommends install libc6:i386 libncurses5:i386 libstdc++6:i386 && rm -rf /var/lib/apt/lists/*;
