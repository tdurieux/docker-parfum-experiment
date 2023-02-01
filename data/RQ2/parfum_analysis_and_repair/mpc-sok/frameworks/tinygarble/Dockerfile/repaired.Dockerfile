FROM ubuntu:16.04
WORKDIR /root
RUN apt-get update && apt-get install --no-install-recommends -y \
  g++ \
  git \
  libboost-all-dev \
  libssl-dev \
  software-properties-common \
  vim \
  yosys && rm -rf /var/lib/apt/lists/*;
RUN ["apt-add-repository", "ppa:george-edison55/cmake-3.x"]
RUN ["apt-get", "update"]
#RUN ["apt-get", "upgrade"]
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
#ADD source/ /root/source
#ADD README.md .
ADD install.sh .
RUN ["bash", "install.sh"]
CMD ["/bin/bash"]

