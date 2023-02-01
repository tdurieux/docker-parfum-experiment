FROM activestate/activepython:2.7

# For Python3 compact
RUN apt-get -y update && apt-get -y --no-install-recommends install python3-setuptools && \
	apt-get -y clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
ADD . /app
RUN python setup.py install && python -m unittest discover
RUN python3 setup.py install && python3 -m unittest

RUN python -m appdirs
RUN python3 -m appdirs
