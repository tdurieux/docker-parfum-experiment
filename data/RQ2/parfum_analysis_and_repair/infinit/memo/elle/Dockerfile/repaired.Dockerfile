FROM ubuntu:16.04 AS trusty-ci

RUN apt-get update && apt-get install --no-install-recommends -y ccache fuse git python3.5 python3-pip valgrind && rm -rf /var/lib/apt/lists/*
ADD drake/requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
