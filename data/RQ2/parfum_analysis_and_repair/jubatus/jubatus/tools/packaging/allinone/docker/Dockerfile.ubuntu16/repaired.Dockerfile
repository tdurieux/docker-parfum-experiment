FROM ubuntu:16.04

ENV DEBEMAIL="jubatus-team@googlegroups.com"
ENV DEBFULLNAME="PFN & NTT"

RUN apt-get update && \
    apt-get install --no-install-recommends -y ssh git build-essential ruby pkg-config autoconf libtool devscripts debhelper apt-utils liblog4cxx10-dev libopencv-dev python2.7 python3-dev && rm -rf /var/lib/apt/lists/*;
