# NODE
from    ubuntu:12.04
maintainer    Matthew Mueller "mattmuelle@gmail.com"

# make sure the package repository is up to date
run    echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
run    apt-get update

# Install ubuntu dependencies
run apt-get install --no-install-recommends -y make python g++ && rm -rf /var/lib/apt/lists/*;

# Install node.js
run apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
run curl -f https://nodejs.org/dist/v0.10.13/node-v0.10.13-linux-x64.tar.gz | tar -C /usr/local/ --strip-components=1 -zxv

