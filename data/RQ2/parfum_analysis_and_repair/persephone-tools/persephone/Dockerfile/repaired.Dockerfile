FROM mtgupf/essentia:ubuntu16.04-python3
#FROM python:3.6 What's the reason for the mtgupf/essentia base image?

RUN apt-get update && apt-get -y --no-install-recommends install \
	python3-pip \
	ffmpeg \
	wget \
	unzip \
	vim \
	sox && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -U pip
RUN pip3 install --no-cache-dir persephone
RUN pip3 install --no-cache-dir ipython

WORKDIR /persephone

ADD https://cloudstor.aarnet.edu.au/plus/s/YJXTLHkYvpG85kX/download data/

RUN mv data/download data/na_example_small.zip
RUN unzip data/na_example_small.zip -d data/ && rm data/na_example_small.zip
