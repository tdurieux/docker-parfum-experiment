# This Dockerfile creates a docker image suitable to run biboumi’s build and
# tests.  For example, it can be used on with gitlab-ci.

FROM docker.io/debian:buster

ENV LC_ALL C.UTF-8

RUN apt update && apt install -y --no-install-recommends \
git \
make \
cmake \
g++ \
libuuid1 \
libudns-dev \
libexpat1-dev \
libidn11-dev \
libsqlite3-dev \
libbotan-2-dev \
libsystemd-dev \
uuid-dev \
libgcrypt20-dev \
libpq-dev \
valgrind \
libasan5 \
libubsan0 \
python3-pip \
python3-lxml \
python3-dev \
wget && rm -rf /var/lib/apt/lists/*; # Needed to build biboumi























RUN wget "https://github.com/oragono/oragono/releases/download/v2.0.0/oragono-2.0.0-linux-x64.tar.gz" && tar xvf oragono-2.0.0-linux-x64.tar.gz && cp oragono-2.0.0-linux-x64/oragono /usr/local/bin && rm oragono-2.0.0-linux-x64.tar.gz

# Install slixmpp, for e2e tests
RUN git clone https://github.com/saghul/aiodns.git && cd aiodns && git checkout 7ee13f9bea25784322~ && python3 setup.py build && python3 setup.py install && git clone https://lab.louiz.org/poezio/slixmpp && pip3 install --no-cache-dir pyasn1 && cd slixmpp && python3 setup.py build && python3 setup.py install

