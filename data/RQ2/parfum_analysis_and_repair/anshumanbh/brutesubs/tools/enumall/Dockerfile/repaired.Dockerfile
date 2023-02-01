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

RUN easy_install pip && pip install --no-cache-dir --upgrade pip

RUN mkdir /opt/subscan
WORKDIR /opt/subscan

RUN git clone https://github.com/lanmaster53/recon-ng.git

# Changing the cwd from /opt/subscan to /opt/subscan/recon-ng. Installing recon-ng, Downloading the custom enumall script and making it executable
WORKDIR /opt/subscan/recon-ng
RUN pip install --no-cache-dir -r REQUIREMENTS && ln -s /opt/subscan/recon-ng /usr/share/recon-ng
RUN wget https://raw.githubusercontent.com/anshumanbh/domain/master/enumall.py && chmod +x enumall.py

RUN mkdir /opt/secdevops
COPY scripts/* /opt/secdevops/
RUN chmod +x /opt/secdevops/*