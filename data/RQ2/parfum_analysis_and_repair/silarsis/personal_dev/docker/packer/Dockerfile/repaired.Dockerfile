# Packer
FROM debian:jessie
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

RUN apt-get -yq update \
    && apt-get -yq --no-install-recommends install curl ca-certificates build-essential git mercurial \
      sudo vim && rm -rf /var/lib/apt/lists/*;

ENV PATH $PATH:/usr/local/go/bin:/usr/local/gopath/bin
ENV GOPATH /usr/local/gopath

RUN curl -f -L https://go.googlecode.com/files/go1.2.src.tar.gz \
    | tar -v -C /usr/local -xz \
    && cd /usr/local/go/src && ./make.bash --no-clean

RUN mkdir -p /usr/local/packer
RUN go get -u github.com/mitchellh/gox

RUN git clone https://github.com/mitchellh/packer.git $GOPATH/src/github.com/mitchellh/packer \
    && cd $GOPATH/src/github.com/mitchellh/packer \
    && make updatedeps \
    && make dev \
    && mkdir -p /usr/local/packer \
    && cp bin/* /usr/local/packer \
    && rm -rf $GOPATH/src

RUN git clone https://github.com/packer-community/packer-windows-plugins.git $GOPATH/src/github.com/packer-community/packer-windows-plugin
RUN cd $GOPATH/src/github.com/packer-community/packer-windows-plugin \
    && make updatedeps \
    && make dev \
    && cp bin/* /usr/local/packer \
    && rm -rf $GOPATH/src

# Python for awscli
RUN apt-get -yq --no-install-recommends install zlib1g-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
ENV PYTHON_VER=2.7.9
RUN cd /usr/local/src \
  && curl -f -sSL https://www.python.org/ftp/python/$PYTHON_VER/Python-$PYTHON_VER.tgz | tar zx \
  && cd Python-$PYTHON_VER \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install \
  && cd /tmp \
  && curl -f -O https://bootstrap.pypa.io/get-pip.py && python /tmp/get-pip.py \
  && rm -rf /usr/local/src/Python-$PYTHON_VER /tmp/get-pip.py
RUN pip install --no-cache-dir awscli docker-compose

RUN chmod go+w /tmp
RUN adduser --disabled-password --gecos "" packer; \
  echo "packer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV HOME /home/packer
USER packer

WORKDIR $HOME

ADD packer.json /home/packer/packer.json
ADD amz.userdata /home/packer/amz.userdata

CMD ["/bin/bash"]
