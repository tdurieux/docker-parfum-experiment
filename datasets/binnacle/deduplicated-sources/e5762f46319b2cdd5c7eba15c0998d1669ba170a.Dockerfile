FROM ubuntu:14.04

ENV DEBEMAIL="jubatus-team@googlegroups.com"
ENV DEBFULLNAME="PFN & NTT"

RUN apt-get update && \
    apt-get install -y ssh git build-essential ruby1.9.3 pkg-config autoconf libtool devscripts debhelper apt-utils liblog4cxx10-dev libopencv-dev python-dev
