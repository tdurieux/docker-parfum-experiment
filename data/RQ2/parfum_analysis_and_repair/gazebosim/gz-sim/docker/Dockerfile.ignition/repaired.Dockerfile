# Purpose
#
#   This docker file is used by build.bash and run.bash to build and run
#   an Ignition distribution based on binaries. See the README.md file.

# Ubuntu 20.04 with nvidia opengl support
FROM nvidia/opengl:1.2-glvnd-devel-ubuntu20.04

# Name of the Ignition distribution
ARG ign_distribution

# Tools I find useful during development
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
        lsb-release \
        sudo \
        gpg \
        wget \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Add a user with the same user_id as the user outside the container
# Requires a docker build argument `user_id`
ARG user_id
ENV USERNAME developer
RUN useradd -U --uid ${user_id} -ms /bin/bash $USERNAME \
 && echo "$USERNAME:$USERNAME" | chpasswd \
 && adduser $USERNAME sudo \
 && echo "$USERNAME ALL=NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME

# Commands below run as the developer user
USER $USERNAME

# When running a container start in the developer's home folder
WORKDIR /home/$USERNAME

RUN export DEBIAN_FRONTEND=noninteractive \
 && sudo apt-get update \
 && sudo -E apt-get install --no-install-recommends -y \
    tzdata \
 && sudo ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime \
 && sudo dpkg-reconfigure --frontend noninteractive tzdata \
 && sudo apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN sudo /bin/sh -c 'echo "deb [trusted=yes] http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
 && sudo /bin/sh -c 'wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -' \
 && sudo /bin/sh -c 'apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116' \
 && sudo apt-get update \
 && sudo apt-get install --no-install-recommends -y \
    ${ign_distribution} \
 && sudo apt-get clean && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["ign-gazebo"]
