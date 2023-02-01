FROM ubuntu:bionic

RUN apt-get update \
	&& apt-get install -y

# need the -dev version so that cffi can work in API mode .. it needs the .pc
# file to work out how to make a binary that's link-compatible with libvips.so
RUN apt-get install --no-install-recommends -y \
	libvips-dev \
	python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir pyvips


