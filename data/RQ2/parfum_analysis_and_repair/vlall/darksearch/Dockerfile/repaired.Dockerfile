FROM ubuntu:14.04
RUN apt-get update && apt-get install --no-install-recommends -y \
	python \
	build-essential \
	python-dev \
	python-pip \
	git \
	wget \
        openjdk-7-jre \
        libblas-dev liblapack-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /home
RUN \
  wget "https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.2.0/elasticsearch-2.2.0.deb" -O elasticsearch-2.2.0.deb && \
  dpkg -i elasticsearch-2.2.0.deb
RUN git clone https://github.com/vlall/darksearch
RUN pip install --no-cache-dir -r /home/darksearch/requirements.txt
