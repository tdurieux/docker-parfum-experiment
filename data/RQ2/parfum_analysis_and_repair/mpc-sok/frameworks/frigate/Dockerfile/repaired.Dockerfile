FROM ubuntu:18.04
WORKDIR /root
RUN apt-get update && apt-get install --no-install-recommends -y \
  g++ \
  git \
  flex \
  make \
  python \
  vim \
  wget && rm -rf /var/lib/apt/lists/*;
ADD source/ /root/source
ADD README.md .
ADD install.sh .

RUN ["bash", "install.sh"]
CMD ["/bin/bash"]

