FROM ubuntu:trusty

USER root
ENV HOME /root

# install packages
RUN apt-get update && apt-get -y --no-install-recommends install wget curl git build-essential libtool autoconf pkgconf && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y mysql-server libmysqld-dev && rm -rf /var/lib/apt/lists/*;

# install go1.9.3
RUN wget https://dl.google.com/go/go1.9.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.9.3.linux-amd64.tar.gz && rm go1.9.3.linux-amd64.tar.gz

RUN mkdir $HOME/go

ENV PATH $PATH:/usr/local/go/bin
ENV GOPATH $HOME/go
RUN echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
RUN echo "export GOPATH=$HOME/go" >> ~/.bashrc

# intall openssl 1.1.1
RUN wget https://www.openssl.org/source/openssl-1.1.1-pre7.tar.gz
RUN tar -C $HOME -xzf openssl-1.1.1-pre7.tar.gz && rm openssl-1.1.1-pre7.tar.gz
WORKDIR $HOME/openssl-1.1.1-pre7
RUN $HOME/openssl-1.1.1-pre7/config
RUN make && make install
RUN echo '/usr/local/lib' >> /etc/ld.so.conf

# install libcoap
WORKDIR $HOME
RUN git clone https://github.com/obgm/libcoap.git
WORKDIR $HOME/libcoap
RUN git checkout 1365dea39a6129a9b7e8c579537e12ffef1558f6
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-documentation --with-openssl
RUN make && make install
RUN ldconfig

# install go-dots
WORKDIR $HOME
RUN go get -u github.com/nttdots/go-dots/...
WORKDIR $GOPATH/src/github.com/nttdots/go-dots/
RUN make && make install