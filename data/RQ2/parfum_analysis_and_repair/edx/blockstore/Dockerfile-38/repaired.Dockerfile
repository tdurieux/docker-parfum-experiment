# Dockerfile

FROM ubuntu:20.04

RUN apt-get update && apt-get install -qy --no-install-recommends \
 build-essential \
 git \
 libmysqlclient-dev \
 make \
 python3-dev \
 python3-pip \
 python3-venv \
 wget && rm -rf /var/lib/apt/lists/*; # git is required by diff-cover
# build-essential, libmysqlclient-dev and python3-dev are required by mysqlclient.










ENV VIRTUAL_ENV=/blockstore/venv
RUN python3 -m venv $VIRTUAL_ENV

RUN echo 'cd /blockstore/app/' > ~/.bashrc.new
RUN echo 'export PATH=$VIRTUAL_ENV/bin:$PATH' >> ~/.bashrc.new
RUN cat ~/.bashrc >> ~/.bashrc.new
RUN mv ~/.bashrc.new ~/.bashrc
