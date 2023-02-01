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
RUN apt-get install --no-install-recommends -y screen && rm -rf /var/lib/apt/lists/*;
# Some config to get screen working nicely
RUN echo "termcapinfo xterm* ti@:te@" >> ~/.screenrc
RUN echo "defshell -bash" >> ~/.screenrc
## START CHANGING STUFF

# Install tools here, (recommended to use multiple lines so they don't have to all reinstall if you change one)
RUN apt-get install --no-install-recommends -y nano && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libtool-bin && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y automake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y autoconf && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libexpat1-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-matplotlib && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-serial && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-wxgtk3.0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-wxtools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-lxml && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-scipy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-opencv && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ccache && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gawk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pexpect && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y tmux && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir future pymavlink MAVProxy

## May need to add DEBIAN_FRONTEND=noninteractive after RUN commands
## apt-get install -y python-software-properties
# RUN apt-get install -y gnome-terminal
# RUN apt-get install -y software-properties-common
# RUN add-apt-repository ppa:deadsnakes/ppa
# RUN apt-get update
# RUN apt-get install -y python3.6


RUN git clone https://github.com/heronsystems/ardupilot.git && cd ardupilot && git submodule update --init --recursive && cd /
RUN git clone https://github.com/tridge/jsbsim.git && cd jsbsim && ./autogen.sh --enable-libraries && make

ENV PATH=$PATH:/ardupilot/Tools/autotest:/jsbsim/src:/usr/lib/ccache

WORKDIR /ardupilot/Tools/autotest

## TMUX Configuration
COPY tmux/.tmux.conf /root/
COPY tmux/.tmux.conf.local /root/


# EXPOSE 5762
