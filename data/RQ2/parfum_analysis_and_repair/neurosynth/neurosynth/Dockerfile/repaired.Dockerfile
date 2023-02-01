# Set the base image to Ubuntu
FROM ubuntu:trusty

# File Author / Maintainer
MAINTAINER Elizabeth DuPre

# Update the sources list and install basic applications
RUN apt-get update && apt-get install -y --no-install-recommends \
tar \
git \
curl \
nano \
wget \
dialog \
net-tools \
build-essential \

# Dependencies for python and java libs
libpng-dev \
freetype* \
libfreetype6-dev \
liblapack-dev \
libatlas-base-dev \
gfortran \
pkg-config \
software-properties-common \

# Install Python and various packages
python \
python-dev \
python-distribute \
python-pip \
python-numpy \
python-scipy \
python-matplotlib \
ipython \
ipython-notebook \
python-pandas \
python-sympy \
python-beautifulsoup \
python-lx && rm -rf /var/lib/apt/lists/*;

# Install Java for Mallet toolbox
RUN add-apt-repository -y ppa:openjdk-r/ppa
RUN apt-get update && apt-get install -y --no-install-recommends \
openjdk-8-jdk \
openjdk-8-jre && rm -rf /var/lib/apt/lists/*;

RUN update-alternatives --config java
RUN update-alternatives --config javac

# Get pip to download and install requirements:
ADD requirements.txt /neurosynth/requirements.txt
WORKDIR /neurosynth
RUN pip install --no-cache-dir -r requirements.txt

ADD . /neurosynth

# install Mallet with curl
RUN curl -f -o mallet-2.0.7.tar.gz https://mallet.cs.umass.edu/dist/mallet-2.0.7.tar.gz
RUN tar xzf mallet-2.0.7.tar.gz && rm mallet-2.0.7.tar.gz
RUN rm mallet-2.0.7.tar.gz
RUN mv mallet-2.0.7 ./neurosynth/resources/mallet
