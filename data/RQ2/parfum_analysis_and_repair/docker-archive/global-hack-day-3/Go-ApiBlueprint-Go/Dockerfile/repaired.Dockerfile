FROM        apiaryio/base-dev-nodejs
MAINTAINER  Apiary <sre@apiary.io>

ENV REFRESHED_AT 2015-09-21

RUN npm install -g aglio && npm cache clean --force;
RUN sudo mkdir -p /doc

RUN sudo apt-get update -qqy && \
    sudo apt-get install --no-install-recommends -y software-properties-common python-software-properties && \
    sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    sudo apt-get update -y && \
    sudo apt-get install --no-install-recommends -y \
      gcc-4.7 \
      g++-4.7 \
      gdb \
      build-essential \
      git-core \
      ruby \
      ruby-dev \
      bundler && \
    sudo apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc

RUN git clone --recursive https://github.com/apiaryio/drafter.git /tmp/drafter
RUN cd /tmp/drafter && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && sudo make install

CMD bash
