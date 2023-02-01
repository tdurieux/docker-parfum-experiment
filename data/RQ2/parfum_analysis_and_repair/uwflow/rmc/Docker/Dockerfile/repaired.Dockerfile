FROM ubuntu:trusty

RUN apt-get update
RUN apt-get -y --no-install-recommends install software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:git-core/ppa
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;

RUN git clone -b docker https://github.com/UWFlow/rmc.git ~/rmc

RUN apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install gcc && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN make -C ~/rmc install
