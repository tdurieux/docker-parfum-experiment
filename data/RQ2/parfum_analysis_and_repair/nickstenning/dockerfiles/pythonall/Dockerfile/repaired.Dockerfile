# DOCKER-VERSION 0.4.0

from ubuntu:12.04
run apt-get -y update
run apt-get -y --no-install-recommends install python-software-properties && rm -rf /var/lib/apt/lists/*;
run add-apt-repository ppa:fkrull/deadsnakes
run apt-get -y update
run apt-get -y --no-install-recommends install python2.4 python2.5 python2.6 python2.7 python3.1 python3.2 python3.3 && rm -rf /var/lib/apt/lists/*;