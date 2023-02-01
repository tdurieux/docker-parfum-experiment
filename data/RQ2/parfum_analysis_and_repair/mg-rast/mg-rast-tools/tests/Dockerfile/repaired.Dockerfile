FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y git make python python-setuptools gcc python-dev python-pytest && rm -rf /var/lib/apt/lists/*;

# setproctile  needs Python.h from python-dev
# requests needs gcc to build
RUN git clone http://github.com/MG-RAST/MG-RAST-Tools
RUN cd MG-RAST-Tools && make install 
