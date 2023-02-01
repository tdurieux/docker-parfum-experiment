FROM ubuntu:20.04
CMD bash

# Install Ubuntu packages.
# Please add packages in alphabetical order.
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
COPY script/installation/packages.sh install-script.sh
RUN echo y | ./install-script.sh all

COPY . /repo

WORKDIR /repo

