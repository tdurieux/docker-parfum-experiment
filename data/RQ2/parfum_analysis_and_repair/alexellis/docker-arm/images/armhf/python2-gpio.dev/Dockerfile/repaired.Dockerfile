FROM alexellis2/python2-armhf:2

# Use a single layer to minimize image size
RUN apt-get -q update && \
	apt-get -qy --no-install-recommends install python-dev python-pip gcc && \
  pip install --no-cache-dir rpi.gpio && rm -rf /var/lib/apt/lists/*;

# dev version retains the build essentials
#  apt-get -qy remove python-dev gcc && \
#	rm -rf /var/lib/apt/lists/* && \
#	apt-get -qy clean all
