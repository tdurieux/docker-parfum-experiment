from	ubuntu:12.04
run apt-get -y update && apt-get -y --no-install-recommends install git ssh && rm -rf /var/lib/apt/lists/*;
run ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
run git clone https://github.com/sstephenson/bats.git && cd bats && ./install.sh /usr/local
add ./gitreceive /usr/local/bin/gitreceive
add ./gitreceive.bats /
add ./init /
cmd /init