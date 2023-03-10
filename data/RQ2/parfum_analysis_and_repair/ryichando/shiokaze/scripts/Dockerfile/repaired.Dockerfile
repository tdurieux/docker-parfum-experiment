FROM ubuntu:14.04

RUN apt-get update

### Apache Installation ###

RUN apt-get install --no-install-recommends -y apache2 && rm -rf /var/lib/apt/lists/*;

### Mitsuba Installation ###

WORKDIR /mitsuba

RUN apt-get install --no-install-recommends -y \
	qt4-dev-tools \
	libpng12-dev \
	libjpeg-dev \
	libilmbase-dev \
	libxerces-c-dev \
	libboost-all-dev \
	libopenexr-dev \
	libglewmx-dev \
	libxxf86vm-dev \
	libpcrecpp0 \
	libeigen3-dev \
	libfftw3-dev \
	libpython3.4 && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://www.mitsuba-renderer.org/releases/current/trusty/collada-dom-dev_2.4.0-1_amd64.deb \
	&& wget https://www.mitsuba-renderer.org/releases/current/trusty/collada-dom_2.4.0-1_amd64.deb \
	&& wget https://www.mitsuba-renderer.org/releases/current/trusty/mitsuba_0.5.0-1_amd64.deb

### COPY ./*.deb ./ ###

RUN dpkg --install collada-dom*.deb
RUN dpkg --install mitsuba_0.5.0-1_amd64.deb

### Shiokaze Dependency Installation ###

RUN apt-get install --no-install-recommends -y git libav-tools gnuplot build-essential ocl-icd-opencl-dev libglfw-dev freeglut3-dev \
	libboost-all-dev libtbb-dev libgsl0-dev gnuplot libpng-dev zlib1g-dev libopenexr-dev libblas-dev && rm -rf /var/lib/apt/lists/*;

### GCC 6 Installation ###

RUN apt-get install --no-install-recommends -y \
	software-properties-common \
	&& add-apt-repository -y ppa:ubuntu-toolchain-r/test \
	&& apt-get update \
	&& apt-get -y --no-install-recommends install g++-6 \
	&& apt-get install --no-install-recommends -y gcc-4.8 g++-4.8 \
	&& update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6 \
	&& update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8 && rm -rf /var/lib/apt/lists/*;

### Clean up ###

RUN apt-get clean \
	&& apt-get autoclean \
	&& apt-get autoremove

### Run after log in ###

RUN echo "service apache2 start > /dev/null 2>&1" > ~/.bash_aliases

WORKDIR /var/www/html