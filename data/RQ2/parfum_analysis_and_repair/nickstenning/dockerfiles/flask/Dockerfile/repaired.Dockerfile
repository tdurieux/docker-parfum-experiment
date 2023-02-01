# DOCKER-VERSION 0.4.0

from ubuntu:12.04
run echo 'deb http://us.archive.ubuntu.com/ubuntu/ precise universe' >> /etc/apt/sources.list
run apt-get -y update && apt-get -y --no-install-recommends install python python-pip build-essential && rm -rf /var/lib/apt/lists/*;
run pip install --no-cache-dir flask flask-sqlalchemy
run apt-get -y purge build-essential
run apt-get -y autoremove