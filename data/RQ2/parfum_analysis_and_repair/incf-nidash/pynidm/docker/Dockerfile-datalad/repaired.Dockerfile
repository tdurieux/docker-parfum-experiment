FROM pynidm:latest

WORKDIR /opt

RUN pip install --no-cache-dir datalad

RUN wget -O- https://neuro.debian.net/lists/bionic.us-nh.full | tee /etc/apt/sources.list.d/neurodebian.sources.list && \
    apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9 && \
    apt-get update

RUN apt-get install --no-install-recommends -y git-annex-standalone && rm -rf /var/lib/apt/lists/*;

RUN datalad install ///abide2/RawData/NYU_1

