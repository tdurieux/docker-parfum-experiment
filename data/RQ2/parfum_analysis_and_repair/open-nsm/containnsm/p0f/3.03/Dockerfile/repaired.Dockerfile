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
# Specify version to download and install (e.g. 3.03b)
ENV VERS 3.03b

# Install dependencies
RUN apt-get update -y && apt-get install --no-install-recommends -y gcc libpcap0.8-dev && rm -rf /var/lib/apt/lists/*;

# Compile and install p0f
USER opennsm
WORKDIR /home/$VIRTUSER
RUN git clone https://github.com/p0f/p0f.git
WORKDIR /home/$VIRTUSER/$PROGRAM
RUN git checkout v$VERS
RUN ./build.sh
USER root
RUN install -m 755 -o root -g root ./$PROGRAM /usr/local/bin/
RUN install -m 644 -o root -g root ./$PROGRAM.fp /home/$VIRTUSER

# Environment
WORKDIR /home/$VIRTUSER
USER opennsm
