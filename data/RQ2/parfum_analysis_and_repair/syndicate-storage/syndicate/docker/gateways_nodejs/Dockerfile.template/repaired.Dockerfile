# Syndicate gateways for node.js
#
# VERSION	1.0

FROM	ubuntu:14.04
MAINTAINER	Illyoung Choi <iychoi@email.arizona.edu>

##############################################
# Setup utility packages
##############################################

RUN apt-get update
RUN apt-get install --no-install-recommends -y wget unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;

##############################################
# Setup a Syndicate account
##############################################
ENV HOME /home/syndicate

RUN useradd syndicate && echo 'syndicate:docker' | chpasswd
RUN echo "syndicate ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN mkdir /home/syndicate
RUN chown -R syndicate:syndicate $HOME

##############################################
# build essentials
##############################################
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

##############################################
# fskit
##############################################
RUN apt-get install --no-install-recommends -y libfuse-dev libattr1-dev && rm -rf /var/lib/apt/lists/*;

USER syndicate
WORKDIR $HOME

RUN wget -O fskit.zip https://github.com/jcnelson/fskit/archive/master.zip
RUN unzip fskit.zip
RUN mv fskit-master fskit
WORKDIR "fskit"
RUN make

USER root
RUN make install

##############################################
# syndicate
##############################################
RUN apt-get install --no-install-recommends -y protobuf-compiler libprotobuf-dev libcurl4-gnutls-dev libmicrohttpd-dev libjson0-dev valgrind cython python-protobuf libssl-dev python-crypto python-requests && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pika python-irodsclient retrying timeout_decorator

USER syndicate
WORKDIR $HOME

RUN wget -O syndicate.zip https://github.com/jcnelson/syndicate/archive/master.zip
RUN unzip syndicate.zip
RUN mv syndicate-master syndicate
WORKDIR "syndicate"
RUN make

USER root
RUN make -C libsyndicate install
RUN make -C libsyndicate-ug install
RUN make -C python install

WORKDIR $HOME/syndicate/gateways/acquisition
RUN make install

WORKDIR $HOME/syndicate/gateways/user
RUN make install

expose $GATEWAY_PORT$

WORKDIR $HOME

##############################################
# node.js
##############################################
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN npm install ffi ref ref-struct ref-array && npm cache clean --force;

RUN wget -O libsyndicate-node.js.zip https://github.com/syndicate-storage/libsyndicate-node.js/archive/master.zip
RUN unzip libsyndicate-node.js.zip
RUN mv libsyndicate-node.js-master libsyndicate-node.js

USER syndicate

