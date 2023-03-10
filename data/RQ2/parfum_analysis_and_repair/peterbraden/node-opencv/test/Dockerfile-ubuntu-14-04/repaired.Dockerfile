# This is a dockerfile to test the build on ubuntu 14.04
from	ubuntu:14.04
run apt-get update -qq
run apt-get install --no-install-recommends -y software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;
run add-apt-repository -y ppa:kubuntu-ppa/backports
run apt-get update
run apt-get install --no-install-recommends -y libcv-dev libcvaux-dev libhighgui-dev libopencv-dev && rm -rf /var/lib/apt/lists/*;
run curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
run apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
WORKDIR /root/node-opencv
add . /root/node-opencv
run npm install --unsafe-perm --build-from-source || cat npm-debug.log && npm cache clean --force;
run make test
