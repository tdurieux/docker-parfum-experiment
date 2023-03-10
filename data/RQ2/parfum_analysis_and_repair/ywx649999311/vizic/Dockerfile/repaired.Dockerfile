FROM       ubuntu:14.04
MAINTAINER Weixiang Yu <wyu16@illinois.edu>

#ENVS
ENV HOME /root
ENV SHELL /bin/bash
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TERM xterm

# BASICS
RUN apt-get update
RUN apt-get install --no-install-recommends -y nano git curl net-tools build-essential vim unzip libaio1 pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gfortran && rm -rf /var/lib/apt/lists/*;

#MONGO
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
RUN echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sour$
RUN sudo apt-get update
RUN sudo apt-get install --no-install-recommends -y mongodb-org && rm -rf /var/lib/apt/lists/*;

# Create the MongoDB data directory
RUN mkdir -p /data/db

# packages for vizic
RUN apt-get install --no-install-recommends -y python3-pip python3-dev python3-numpy && rm -rf /var/lib/apt/lists/*;
RUN sudo pip3 install --no-cache-dir --upgrade pip
RUN sudo pip3 install --no-cache-dir tornado
RUN sudo pip3 install --no-cache-dir motor==1.0
RUN sudo pip3 install --no-cache-dir pandas
RUN sudo pip3 install --no-cache-dir jupyter
RUN sudo pip3 install --no-cache-dir requests uuid

RUN sudo pip install --no-cache-dir vizic

# enable jupyter extensions
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension
RUN jupyter nbextension enable --py --sys-prefix vizic

# Expose port #8888 from the container to the host
EXPOSE 8888
