FROM ubuntu:18.04

# Setup basic environment
RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

# Install git
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN git --version

# Install python
RUN apt-get update
RUN apt-get install --no-install-recommends -y python3 python3-dev python3-pip graphviz && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pytest
RUN rm -rf /var/lib/apt/lists/*

ENV PYTHONIOENCODING utf-8

# Install misc
RUN apt-get update
RUN apt-get install --no-install-recommends -y sudo vim wget curl && rm -rf /var/lib/apt/lists/*;

# Install spot. Run this here so that if we make changes to the stuff below, we don't have to rebuild spot
RUN curl -f -sSL https://raw.githubusercontent.com/ReedOei/Pecan/master/scripts/install-spot.sh | bash

WORKDIR /home/pecan

RUN git clone --recursive "https://github.com/ReedOei/Pecan" "ReedOei/Pecan"
RUN git clone --recursive "https://github.com/ReedOei/SturmianWords" "ReedOei/Pecan/SturmianWords"

WORKDIR /home/pecan/ReedOei/Pecan

RUN pip3 install --no-cache-dir -r requirements.txt
# Install my custom version of PySimpleAutomata
RUN ( cd PySimpleAutomata; pip3 install --no-cache-dir .)
RUN pytest --verbose test

