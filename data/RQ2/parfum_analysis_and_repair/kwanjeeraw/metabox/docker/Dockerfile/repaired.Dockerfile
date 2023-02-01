FROM ubuntu:14.04
MAINTAINER Sajjan Singh Mehta "ssmehta@ucdavis.edu"

# Set non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

# Install OpenCPU
RUN apt-get update && \
	apt-get -y dist-upgrade && \
	apt-get install --no-install-recommends -y software-properties-common && \
	add-apt-repository -y ppa:opencpu/opencpu-1.6 && \
	apt-get update && \
	apt-get install --no-install-recommends -y opencpu && rm -rf /var/lib/apt/lists/*;

# Install R and additional dependencies
RUN apt-get -y --no-install-recommends install \
	r-base-core \
	libcurl4-gnutls-dev \
	libssl-dev \
	libgsl0-dev \
	libxml2-dev \
	libprotobuf-dev \
	protobuf-compiler && rm -rf /var/lib/apt/lists/*;

# Install Metabox
COPY R.install /tmp
RUN Rscript /tmp/R.install && \
	rm /tmp/R.install

# Add OpenCPU configuration
RUN mkdir -p /etc/opencpu/
COPY server.conf /etc/opencpu

# Apache ports
EXPOSE 80
EXPOSE 443
EXPOSE 8004

CMD service opencpu restart && tail -F /var/log/opencpu/apache_access.log

