FROM balenalib/rpi-raspbian:buster
MAINTAINER Scott Evans <docker@scott.ee>

LABEL unicorn_version="0.0.2" architecture="ARMv7"

# Data directory
RUN mkdir /data

# Install dependencies
RUN apt-get update && apt-get install -y \
	git-core \
	build-essential \
	gcc \
	python \
	python-dev \
	python-pip \
	python-virtualenv \
	python-setuptools \
	--no-install-recommends && \
	rm -rf /var/lib/apt/lists/*


WORKDIR /root/
#RUN git clone https://github.com/pimoroni/unicorn-hat
#WORKDIR /root/unicorn-hat/library/UnicornHat
#  Change pin
#RUN sed -i 's/=\ 18      #/=\ 12      #/g' unicornhat.py
#RUN python setup.py install

RUN pip install --no-cache-dir rpi.gpio
RUN pip install --no-cache-dir paho-mqtt
RUN pip install --no-cache-dir unicornhat
RUN pip install --no-cache-dir simplejson
RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir bitarray

# Define working directory
WORKDIR /data

CMD ["python"]
