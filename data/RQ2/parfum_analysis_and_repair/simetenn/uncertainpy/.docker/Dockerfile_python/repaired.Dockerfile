#FROM python:3.7
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Python prerequisites
RUN apt-get update --fix-missing
RUN apt-get -y --no-install-recommends install python3-pip software-properties-common > /dev/null && rm -rf /var/lib/apt/lists/*;


ENV HOME=/home/docker
RUN mkdir $HOME

RUN pip3 install --no-cache-dir neuron

RUN add-apt-repository ppa:nest-simulator/nest
RUN apt-get update
RUN apt-get install --no-install-recommends -y nest && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/docker/

# Install uncertainpy dependencies
RUN apt-get -y --no-install-recommends install xvfb hdf5-tools && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir coverage setuptools xvfbwrapper

# Make sure matplotlib uses agg
RUN mkdir .config/
RUN mkdir .config/matplotlib
RUN echo "backend : Agg" >> .config/matplotlib/matplotlibrc


RUN echo 'alias python="/usr/bin/python3"' >> /root/.bash_aliases && \
    echo 'alias pip="/usr/bin/pip3"' >> /root/.bash_aliases