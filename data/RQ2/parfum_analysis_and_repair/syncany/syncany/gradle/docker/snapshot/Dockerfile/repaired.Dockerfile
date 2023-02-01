# 
# Docker file for Syncany (SNAPSHOT) 
#
# Build:
#  docker build -t syncany/snapshot .
# 
# Run:
#  docker run -ti syncany/snapshot
#
# Tries to follow this tutorial:
#  http://container-solutions.com/2014/11/6-dockerfile-tips-official-images/
#

FROM debian:jessie
MAINTAINER Philipp Heckel <philipp.heckel@gmail.com>

# Install Syncany and dependencies, then add 'syncany' user