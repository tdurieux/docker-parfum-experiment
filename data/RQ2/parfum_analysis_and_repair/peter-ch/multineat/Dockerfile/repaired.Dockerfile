FROM ubuntu:18.10

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y git cmake libboost-all-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y python-setuptools python-psutil python-numpy python-concurrent.futures python-opencv && rm -rf /var/lib/apt/lists/*;
RUN cd /opt && git clone https://github.com/peter-ch/MultiNEAT.git
RUN cd /opt/MultiNEAT && export MN_BUILD=boost && cmake . && python setup.py build_ext && python setup.py install



