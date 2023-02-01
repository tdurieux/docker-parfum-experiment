#Download base image ubuntu 18.04
FROM ubuntu:18.04

RUN apt update

RUN apt install cmake git build-essential qtbase5-dev libqt5svg5-dev libqt5websockets5-dev libqt5opengl5-dev libqt5x11extras5-dev nano qt5-default -y && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean


