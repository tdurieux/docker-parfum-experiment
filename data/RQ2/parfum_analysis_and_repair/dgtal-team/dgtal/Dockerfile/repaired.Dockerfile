#Download base image
ARG UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION} as base
# LABEL about the custom image
LABEL maintainer="msalazar@centrogeo.edu.mx"
LABEL version="0.0.1"
LABEL description="This Docker is for the Dgtal library installation."
ARG DEBIAN_FRONTEND=noninteractive



###Update
RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

##### Basics
RUN apt install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
#### Install Git
RUN apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
#### Install G++
RUN apt install -y --no-install-recommends g++ && rm -rf /var/lib/apt/lists/*;


#### gl libraries
RUN apt -y update --fix-missing
#RUN apt -y install libx11-dev
RUN apt -y --no-install-recommends install mesa-common-dev libglm-dev mesa-utils && rm -rf /var/lib/apt/lists/*;


### Install cmake
RUN apt -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;
###Install boost
RUN apt -y --no-install-recommends install libboost-all-dev && rm -rf /var/lib/apt/lists/*;
###Install clang-9
RUN apt -y --no-install-recommends install clang-9 && rm -rf /var/lib/apt/lists/*;

RUN apt -y --no-install-recommends install libcgal* && rm -rf /var/lib/apt/lists/*;

RUN apt -y --no-install-recommends install libmagick++-dev && rm -rf /var/lib/apt/lists/*;

RUN apt -y --no-install-recommends install graphicsmagick* && rm -rf /var/lib/apt/lists/*;

RUN apt -y --no-install-recommends install doxygen && rm -rf /var/lib/apt/lists/*;

RUN apt -y --no-install-recommends install libcgal-dev && rm -rf /var/lib/apt/lists/*;

RUN apt -y --no-install-recommends install libinsighttoolkit4-dev && rm -rf /var/lib/apt/lists/*;

RUN apt -y --no-install-recommends install libqglviewer-dev-qt5 && rm -rf /var/lib/apt/lists/*;

RUN apt -y --no-install-recommends install libgmp-dev && rm -rf /var/lib/apt/lists/*;

RUN apt -y --no-install-recommends install libeigen3-dev && rm -rf /var/lib/apt/lists/*;

RUN apt -y --no-install-recommends install libfftw3-dev && rm -rf /var/lib/apt/lists/*;

#### User to install
RUN groupadd -g 1000 digital
RUN useradd -d /home/digital -s /bin/bash -m digital -u 1000 -g 1000
RUN usermod -aG sudo digital
####

RUN apt -y --no-install-recommends install mesa-common-dev libglm-dev mesa-utils && rm -rf /var/lib/apt/lists/*;

### Directory to  store the git
RUN mkdir /home/digital/git/
RUN mkdir /home/digital/git/DGtal


#### clone git and install
RUN git clone https://github.com/DGtal-team/DGtal.git /home/digital/git/DGtal

RUN mkdir /home/digital/git/DGtal/build
RUN cd /home/digital/git/DGtal/build &&  cmake .. -DWITH_GMP=true -DWITH_EIGEN=true -DWITH_FFTW3=true -DWITH_CGAL=true -DWITH_ITK=true -DWITH_OPENMP=true -DWITH_CAIRO=true -DWITH_QGLVIEWER=true -DWITH_MAGICK=true && make install


