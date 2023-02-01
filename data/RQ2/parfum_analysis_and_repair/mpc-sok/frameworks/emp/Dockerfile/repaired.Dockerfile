FROM ubuntu:18.04
WORKDIR /root
RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential \
  cmake \
  git \
  libssl-dev \
  sudo \
  wget \
  python \
  vim && rm -rf /var/lib/apt/lists/*;
ADD sh_test/ /root/sh_test
ADD ag_test/ /root/ag_test
ADD README.md .
ADD install.sh .
RUN ["bash", "install.sh"]
CMD ["/bin/bash"]

