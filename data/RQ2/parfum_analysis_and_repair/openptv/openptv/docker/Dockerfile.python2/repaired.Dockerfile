# A Dockerfile for an Ubuntu machine that can compile liboptv and the Cython extensions

FROM ubuntu:18.04

RUN apt-get update
RUN apt-get --assume-yes -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get --assume-yes -y --no-install-recommends install g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get --assume-yes -y --no-install-recommends install python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir virtualenv
RUN virtualenv /env --python=`which python2`
