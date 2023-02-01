FROM stackbrew/debian:jessie
RUN apt-get update && apt-get install --no-install-recommends -y python python-setuptools && rm -rf /var/lib/apt/lists/*;

ADD . /shadowsocks

WORKDIR /shadowsocks
RUN python setup.py install
CMD ssserver
