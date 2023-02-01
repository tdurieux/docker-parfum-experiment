FROM ubuntu:16.04
WORKDIR /root
RUN apt-get update && apt-get install --no-install-recommends -y \
  autoconf \
  binutils \
  g++ \
  make \
  ocaml \
  python \
  screen \
  unzip \
  vim \
  wget && rm -rf /var/lib/apt/lists/*;
ADD source/ ./source
ADD README.md .
ADD install.sh .
RUN ["bash", "install.sh"]
CMD ["/bin/bash"]


