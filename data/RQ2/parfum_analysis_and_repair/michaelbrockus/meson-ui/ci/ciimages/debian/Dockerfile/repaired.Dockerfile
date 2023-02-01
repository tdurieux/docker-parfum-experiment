FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive
ENV LANG='C.UTF-8'

# Use Native Package Manager
RUN apt-get update --fix-missing && apt-get upgrade -y
RUN apt-get -y --no-install-recommends install apt-utils python3 python3-pip python3-wheel python3-setuptools && rm -rf /var/lib/apt/lists/*;

# Upgrade 'pip' package manager
RUN pip3 -q --no-cache-dir install --upgrade pip

# Add Python Scripts
ADD install.py .

# Run Python Scripts
RUN python3 install.py
