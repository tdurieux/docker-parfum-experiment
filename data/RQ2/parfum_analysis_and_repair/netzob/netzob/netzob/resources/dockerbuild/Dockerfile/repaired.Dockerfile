from debian:latest
run yes y | apt-get update && yes y | apt-get upgrade
run yes y | apt-get install -y --no-install-recommends python python-dev && rm -rf /var/lib/apt/lists/*;
run yes y | apt-get install -y --no-install-recommends python-pip python-setuptools && rm -rf /var/lib/apt/lists/*;
run yes y | apt-get install -y --no-install-recommends python-babel python-sphinx && rm -rf /var/lib/apt/lists/*;
run yes y | apt-get install -y --no-install-recommends python-numpy python-pcapy && rm -rf /var/lib/apt/lists/*;
run yes y | apt-get install -y --no-install-recommends gcc make && rm -rf /var/lib/apt/lists/*;
run yes y | apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;
run yes y | apt-get install -y --no-install-recommends ipython && rm -rf /var/lib/apt/lists/*;
workdir root
run git clone https://dev.netzob.org/git/netzob -b next
workdir netzob
run python setup.py build
run python setup.py develop
run python setup.py install
workdir /root
run mkdir -p /root/.ipython/profile_default/startup/
run echo "from netzob.all import *" > /root/.ipython/profile_default/startup/00_netzob.py
cmd /usr/bin/ipython
