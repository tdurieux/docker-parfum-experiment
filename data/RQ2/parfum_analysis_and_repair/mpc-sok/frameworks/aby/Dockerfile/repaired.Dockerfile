FROM ubuntu:16.04
WORKDIR /root
RUN apt-get update && apt-get install --no-install-recommends -y \
  git \
  lzip \
  m4 \
  make \
  libgmp-dev \
  libglib2.0-dev \
  libssl-dev \
  software-properties-common \
  vim \
  wget && rm -rf /var/lib/apt/lists/*;
ADD source/ /root/source
ADD README.md .

ADD install_dependencies.sh .
RUN ["bash", "install_dependencies.sh"]

ADD install.sh .
RUN ["bash", "install.sh"]
CMD ["/bin/bash"]

