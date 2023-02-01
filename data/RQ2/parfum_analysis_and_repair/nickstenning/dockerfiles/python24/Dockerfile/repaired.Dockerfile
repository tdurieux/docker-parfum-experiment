# DOCKER-VERSION 0.4.0

from ubuntu:12.04
run apt-get -y update
run apt-get -y --no-install-recommends install python-software-properties && rm -rf /var/lib/apt/lists/*;
run add-apt-repository ppa:fkrull/deadsnakes
run apt-get -y update
run apt-get -y --no-install-recommends install python2.4 && rm -rf /var/lib/apt/lists/*;
