FROM ubuntu:latest

MAINTAINER Brian Sidebotham <brian.sidebotham@gmail.com>

RUN apt-get update -y

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y tzdata && rm -rf /var/lib/apt/lists/*;
RUN echo "Etc/UTC" > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get install --no-install-recommends -y mtools curl xz-utils git cmake dosfstools gcc-arm-none-eabi && rm -rf /var/lib/apt/lists/*;
COPY . /tutorial

RUN /tutorial/firmware/get_firmware_repo.sh

# Remove some unnecessary crud to reduce the size of the image
RUN rm -rf /tutorial/firmware/firmware/.git || exit 0
RUN apt-get remove -y git
RUN apt-get auto-remove -y

CMD ["/bin/bash"]

WORKDIR /tutorial
