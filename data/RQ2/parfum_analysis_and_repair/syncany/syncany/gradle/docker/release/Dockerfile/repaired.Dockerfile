# 
# Docker file for Syncany
#
# Build:
#  docker build -t syncany/release .
# 
# Run:
#  docker run -ti syncany/release
#
# Tries to follow this tutorial:
#  http://container-solutions.com/2014/11/6-dockerfile-tips-official-images/
#

FROM debian:jessie
MAINTAINER Philipp Heckel <philipp.heckel@gmail.com>

# Install Syncany and dependencies, then add 'syncany' user