FROM debian:latest

RUN apt-get update && apt-get install --no-install-recommends -y python python-dev python-pip zlib1g-dev \
     libxml2-dev libxslt1-dev python-dev libncurses5-dev && rm -rf /var/lib/apt/lists/*;
ADD . /okcupyd
RUN cd /okcupyd && python setup.py install