FROM ubuntu:16.04
WORKDIR /root
RUN apt-get update && apt-get install --no-install-recommends -y \
  bison \
  flex \
  g++ \
  git \
  libwww-perl \
  make \
  patch \
  python \
  wget \
  vim && rm -rf /var/lib/apt/lists/*;
ADD source/ /root/source
ADD README.md .
ADD install.sh .
RUN ["bash", "install.sh"]
CMD ["/bin/bash"]


