# Dockerfile for building the ffmpeg Debian package. Build the image like this:
#
# docker build -t bbb-ffmpeg-build .
#
# Run the container like
# this:
#
# docker run --rm -v `pwd`:/tmp/build/ bbb-ffmpeg-build
#
# The volume is the path where you want the package written into by the
# container after the build process finishes.

FROM ubuntu:14.04
MAINTAINER Juan Luis Baptiste juan.baptiste@gmail.com

RUN apt-get -y update && apt-get install --no-install-recommends -y build-essential checkinstall git libvorbis-dev libvpx-dev vim wget yasm && rm -rf /var/lib/apt/lists/*;

ADD install-ffmpeg.sh /usr/bin/

CMD /usr/bin/install-ffmpeg.sh -f 2.3.3