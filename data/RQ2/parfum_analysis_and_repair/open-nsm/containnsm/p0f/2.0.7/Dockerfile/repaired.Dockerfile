# VERSION               0.1

FROM       opennsm/debian
MAINTAINER Syed Huq <deedarhuq@gmail.com>

# Metadata
LABEL organization=opennsm
LABEL program=p0f

# Specify container username e.g. training, demo
ENV VIRTUSER opennsm
# Program name
ENV PROGRAM p0f
# Specify version to download and install (e.g. 2.0.7)
ENV VERS 2.0.7

# Install dependencies
RUN apt-get update -y && apt-get install --no-install-recommends -y gcc libpcap0.8-dev make && rm -rf /var/lib/apt/lists/*;

# Compile and install p0f
USER opennsm
WORKDIR /home/$VIRTUSER
RUN git clone https://github.com/p0f/p0f.git
WORKDIR /home/$VIRTUSER/$PROGRAM
RUN git checkout v$VERS
RUN ./Build
USER root
RUN install -m 755 -o root -g root ./$PROGRAM /usr/local/bin/
RUN mkdir /etc/p0f && install -m 644 -o root -g root ./$PROGRAM.fp /etc/p0f

# Environment
WORKDIR /home/$VIRTUSER
USER opennsm
