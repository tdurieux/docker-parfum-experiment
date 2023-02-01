FROM ubuntu

RUN apt-get -y update
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install build-essential python3 python3-pip python2.7 python2.7-dev python python-setuptools git wget automake cmake gdb libssl-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /unicorefuzz
ADD requirements.txt ./
Add . ./
RUN ./setup.sh

# Fix https://github.com/keystone-engine/keystone/issues/386
RUN pip3 install --user -U --no-cache-dir --force-reinstall --no-binary keystone-engine keystone-engine
