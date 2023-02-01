FROM ubuntu:16.04
# MAINTAINER Thom Nichols "thom@thomnichols.org"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -qq update
RUN apt-get install --no-install-recommends -y nodejs npm && rm -rf /var/lib/apt/lists/*;
# TODO could uninstall some build dependencies

# debian installs `node` as `nodejs`
RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10


# done installing node

RUN apt-get -y update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:fkrull/deadsnakes
RUN apt-get -y update

# RUN apt-get install -y make
# RUN apt-get install -y vim
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python2.7 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y llvm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y clang-3.6 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc-multilib && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y g++-multilib && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libx11-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sox && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsox-fmt-all && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libasound2-plugins && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y php7.0-cli && rm -rf /var/lib/apt/lists/*;
# RUN apt-get install -y ffmpeg

# RUN npm install -g yarn

# RUN mkdir home/class_transcribe; wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=0B4iG4F78AllkNi1vSnU4QUs4SnM' -O home/htk.tar.gz;tar -xvf home/htk.tar.gz -C home

# WORKDIR home/htk
# RUN ./configure --disable-hslab --prefix=/usr/local; make all; make install

# WORKDIR ..
RUN git clone https://github.com/ucbvislab/p2fa-vislab
RUN wget https://bootstrap.pypa.io/get-pip.py; python get-pip.py; pip install --no-cache-dir numpy

WORKDIR p2fa-vislab
RUN pip install --no-cache-dir -r requirements.txt; git submodule init; git submodule update

WORKDIR /
RUN git clone -b fa18-demo https://github.com/cs-education/classTranscribe.git
WORKDIR classTranscribe

#VOLUME ["/data"]
ADD cert /classTranscribe/cert
RUN npm install && npm cache clean --force;

RUN npm cache clean --force -f
RUN npm install -g n && npm cache clean --force;
RUN n stable

EXPOSE 8000