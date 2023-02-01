FROM ubuntu:latest
MAINTAINER Anshuman Bhartiya <anshuman.bhartiya@gmail.com>

# Doing the usual here
RUN apt-get -y update && \
    apt-get -y dist-upgrade

RUN apt-get install --no-install-recommends -y \
	build-essential \
	git \
	libpcap-dev \
	libxml2-dev \
	libxslt1-dev \
	python-requests \
	python-dnspython \
	python-setuptools \
	python-dev \
	wget \
	zlib1g-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN mkdir /opt/subscan
WORKDIR /opt/subscan

RUN git clone https://github.com/aboul3la/Sublist3r.git

RUN mkdir /opt/secdevops
COPY scripts/* /opt/secdevops/
RUN chmod +x /opt/secdevops/*