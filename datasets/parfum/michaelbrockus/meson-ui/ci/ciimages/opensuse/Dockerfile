FROM opensuse/tumbleweed:latest

ENV DEBIAN_FRONTEND noninteractive
ENV LANG='C.UTF-8'

# Use Native Package Manager
RUN zypper patch --with-update --with-optional && zypper update
RUN zypper install -y python3 python3-pip python3-wheel python3-setuptools

# Upgrade 'pip' package manager
RUN pip3 -q install --upgrade pip

# Add Python Scripts
ADD install.py .

# Run Python Scripts
RUN python3 install.py
