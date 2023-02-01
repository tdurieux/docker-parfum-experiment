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
#Download base image ubuntu 16.04
FROM ubuntu:16.04

# Update Ubuntu Software repository
RUN apt-get update
RUN apt-get update
RUN apt-get update
## START CHANGING STUFF

# Install tools here, (recommended to use multiple lines so they don't have to all reinstall if you change one)
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nano && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y tmux && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y qt5-default && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libqt5serialport5-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-system-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade virtualenv
