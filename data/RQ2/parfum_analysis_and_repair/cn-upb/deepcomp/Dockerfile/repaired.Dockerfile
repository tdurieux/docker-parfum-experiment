FROM ubuntu:focal

# installation
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
    cmake build-essential zlib1g-dev python3-dev python3-pip ffmpeg imagemagick rsync && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir deepcomp

# start tensorboard and http server (for rendered videos)
ADD docker_start.sh docker_start.sh
RUN chmod +x docker_start.sh
CMD ./docker_start.sh

# expose corresponding ports
EXPOSE 6006 8000
