# syntax = edrevo/dockerfile-plus

INCLUDE+ Dockerfile.ros-ubuntu:14.04

RUN sudo apt-get update && sudo apt-get dist-upgrade -y