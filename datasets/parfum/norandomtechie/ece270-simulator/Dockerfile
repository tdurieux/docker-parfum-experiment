FROM ubuntu:20.04
LABEL maintainer="niraj@purdue.edu"
LABEL version="2.0"
LABEL description="Docker container \
for hosting the ECE 270 simulator developed for Purdue University"
# Update container
ARG DEBIAN_FRONTEND=noninteractive
ARG INSIDE_DOCKER=YES
RUN apt-get update -y
RUN apt-get upgrade -y
# Install git
RUN apt-get install -y git wget
# Download simulator codebase
#RUN git clone https://github.com/norandomtechie/ece270-simulator /root/ece270-simulator/
COPY . /root/ece270-simulator/
# Allow connections from outside the container
RUN sh -c "sed -i 's/127.0.0.1/0.0.0.0/g' /root/ece270-simulator/cluster.js"
# Run setup.sh script
RUN sh -c "cd /root/ece270-simulator && bash setup/setup.sh"
# start server
CMD cd /root/ece270-simulator && node cluster.js
