# This image is intended for testing Turi Create on Ubuntu 18.04.

FROM ubuntu:18.04

# Prevent apt-get from asking questions and expecting answers
ENV DEBIAN_FRONTEND noninteractive

# Update package database
RUN apt-get update

# Upgrade all possible packages
RUN apt-get -y upgrade

# Install Python 3.6 and 3.7 with apt, as well as
# turicreate and upstream dependencies
RUN apt-get -y --no-install-recommends install python3.6 python3.6-distutils python3.7 python3.7-distutils libgomp1 lsb-release npm nodejs doxygen zip && rm -rf /var/lib/apt/lists/*;

# Install Python 3.8
RUN apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get -y --no-install-recommends install python3.8 && rm -rf /var/lib/apt/lists/*;

# Install Python 3.9
RUN apt-get update
RUN apt-get -y --no-install-recommends install python3.9 python3.9-distutils && rm -rf /var/lib/apt/lists/*;

# Install build-essential (needed by numpy, which tries to
# build itself from source on 3.6 and above)
RUN apt-get -y --no-install-recommends install build-essential libpython3.6-dev libpython3.7-dev && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/include/locale.h /usr/include/xlocale.h

# Install pip and virtualenv
ADD https://bootstrap.pypa.io/get-pip.py /src/get-pip.py
WORKDIR /src
RUN python3.6 get-pip.py
RUN pip3.6 install virtualenv
RUN python3.7 get-pip.py
RUN pip3.7 install virtualenv
RUN python3.8 get-pip.py
RUN pip3.8 install virtualenv
RUN python3.9 get-pip.py
RUN pip3.9 install virtualenv
