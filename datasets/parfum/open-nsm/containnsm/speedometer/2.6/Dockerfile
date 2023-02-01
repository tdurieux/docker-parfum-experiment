# speedometer 2.6
# VERSION               0.1

FROM       opennsm/debian
MAINTAINER Jon Schipp <jonschipp@gmail.com>

# Metadata
LABEL organization=opennsm
LABEL program=speedometer

# Specify container username e.g. training, demo
ENV VIRTUSER opennsm
# Program name
ENV PROGRAM speedometer
# Specify speedometer version to download and install (e.g. 2.6)
ENV VERS 2.6

# Install dependencies
RUN apt-get update -y
RUN apt-get install -y python python-urwid --no-install-recommends

# Compile and install speedometer
USER opennsm
WORKDIR /home/$VIRTUSER
RUN git clone https://github.com/wardi/speedometer
WORKDIR /home/$VIRTUSER/speedometer
RUN git checkout release-$VERS
USER root
WORKDIR /home/$VIRTUSER/speedometer
RUN cp speedometer.py /usr/local/bin/speedometer

# Environment
WORKDIR /home/$VIRTUSER
USER opennsm
