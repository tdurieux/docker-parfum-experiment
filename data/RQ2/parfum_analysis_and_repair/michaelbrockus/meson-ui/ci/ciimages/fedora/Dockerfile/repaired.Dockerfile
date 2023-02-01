FROM fedora:latest

ENV DEBIAN_FRONTEND noninteractive
ENV LANG='C.UTF-8'

# Use Native Package Manager
RUN dnf -y update && dnf upgrade --refresh
RUN dnf -y install python3 python3-pip python3-wheel python3-setuptools

# Upgrade 'pip' package manager
RUN pip3 -q --no-cache-dir install --upgrade pip

# Add Python Scripts
ADD install.py .

# Run Python Scripts
RUN python3 install.py
