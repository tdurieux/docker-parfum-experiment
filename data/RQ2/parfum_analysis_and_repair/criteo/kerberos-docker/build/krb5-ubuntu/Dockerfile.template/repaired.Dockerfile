# Dockerfile - minimal-ubuntu
#
# usage: docker build -t minimal-ubuntu .

FROM ubuntu:16.04

# environment variables
ENV DEBIAN_FRONTEND noninteractive

# build environment
WORKDIR /root/

# update
RUN apt update -y

# editor
RUN apt install --no-install-recommends -y vim nano && rm -rf /var/lib/apt/lists/*;

# general
RUN apt install --no-install-recommends -y sudo sshpass && rm -rf /var/lib/apt/lists/*;

# network commands
RUN apt install --no-install-recommends -y net-tools && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y iputils-ping && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y dnsutils && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y lsof && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y curl wget && rm -rf /var/lib/apt/lists/*;

# python
RUN apt install --no-install-recommends -y python-dev && rm -rf /var/lib/apt/lists/*;
RUN curl -f "https://bootstrap.pypa.io/pip/2.7/get-pip.py" -o /tmp/get-pip.py
RUN python /tmp/get-pip.py

# java
RUN apt install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
# maven
RUN apt install --no-install-recommends -y maven=3.3.9-3 && rm -rf /var/lib/apt/lists/*;

# supervisord
RUN pip install --no-cache-dir supervisor==3.3.3
RUN mkdir -p /var/log/supervisord/
