FROM debian:stretch

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update && \
  apt-get install --no-install-recommends --yes git wget && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends --yes python3 python3-venv && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/bats-core/bats-core.git && \
  cd bats-core && \
  git checkout v1.1.0 && \
  ./install.sh /usr/local && \
  cd .. && \
  rm -rf bats-core

RUN git clone https://github.com/ztombol/bats-support /usr/local/libexec/bats-support && \
  cd /usr/local/libexec/bats-support && \
  git checkout v0.3.0

RUN git clone https://github.com/jasonkarns/bats-assert-1 /usr/local/libexec/bats-assert && \
  cd /usr/local/libexec/bats-assert && \
  git checkout v2.0.0

RUN version=v0.7.0 && \
  package=shellcheck-$version && \
  archive=$package.linux.x86_64.tar.xz && \
  wget -P /tmp https://github.com/koalaman/shellcheck/releases/download/$version/$archive && \
  cd /tmp && \
  tar xf $archive && \
  mv $package/shellcheck /opt && \
  rm -rf $archive $package

ENV PATH=/root/.local/bin:/opt/sdd/bin:$PATH

RUN echo 'set -o vi' >> /root/.bashrc

CMD ["/bin/bash"]
