FROM ubuntu:bionic
MAINTAINER Onica Group LLC <https://github.com/onicagroup>

RUN set -xe && \
  apt-get update && \
  apt-get -y --no-install-recommends install \
    curl \
    git \
    nano \
    npm \
    python-pip \
    unzip \
    uuid-runtime \
    vim && \
  rm -rf /var/lib/apt/lists/* && \
  update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10 && \
  npm install npm@latest -g && \
  curl -f -L oni.ca/runway/latest/linux -o runway && \
  chmod +x runway && \
  mv runway /usr/local/bin && npm cache clean --force;

CMD ["bash"]
