# Docker image based on Ubuntu 16.04

FROM ubuntu:16.04

# Build required packages
RUN apt-get -y update && apt-get install --no-install-recommends -y python git cmake libsdl2-dev libsdl2-ttf-dev liblua5.2-dev libboost1.58-all-dev && rm -rf /var/lib/apt/lists/*;

