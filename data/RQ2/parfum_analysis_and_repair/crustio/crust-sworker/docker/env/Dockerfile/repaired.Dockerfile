# crust sworker env image
FROM ubuntu:18.04

# install build depends
RUN apt-get update
RUN apt-get install --no-install-recommends -y wget expect kmod unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-all-dev libleveldb-dev build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y linux-headers-`uname -r` libssl-dev curl libprotobuf-dev libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;
ADD resource /crust-sworker-env/resource
ADD scripts/*.sh /crust-sworker-env/scripts/
ADD VERSION /crust-sworker-env/
RUN /crust-sworker-env/scripts/install_deps.sh -u
