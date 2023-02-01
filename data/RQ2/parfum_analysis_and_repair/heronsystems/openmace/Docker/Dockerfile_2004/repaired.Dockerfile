# README
#####
# Build & Rebuild with the following command
# sudo docker build -t ubuntu1604:mace .
#####
###
# Now is a good time to learn how to use screen, otherwise the following commands will help you attach/detach and open new terminals
###
### Run and attach with a terminal with:
# sudo docker run -it ubuntu1604:mace
###
# To detach use: Ctrl+p + Ctrl+q
###
# To reattach: sudo docker attach [CONTAINER-ID] (you may have to press enter again to get the command line back)
###
# To start a new bash shell (so you don't interrupt something else you were running)
#     sudo docker exec -ti [CONTAINER-ID] bash
# With a new bash shell run "exit" instead of Ctrl+p + Ctrl+q
#####

## DON'T CHANGE THIS STUFF
#Download base image ubuntu 20.04
FROM ubuntu:20.04

# Update Ubuntu Software repository
RUN apt update
## START CHANGING STUFF

# Install tools here, (recommended to use multiple lines so they don't have to all reinstall if you change one)
RUN apt install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y nano && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y tmux && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN apt update
# RUN apt install -y qt5-default
RUN apt install --no-install-recommends -y libqt5serialport5-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libboost-system-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y pkg-config && rm -rf /var/lib/apt/lists/*;
# RUN apt install -y liblz4-dev

RUN git clone https://github.com/heronsystems/OpenMACE.git

WORKDIR /
