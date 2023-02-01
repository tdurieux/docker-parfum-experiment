FROM ubuntu:18.04

USER root
ENV HOME /home

# install packages
RUN apt-get update && apt-get -y --no-install-recommends install wget curl git build-essential autoconf automake libtool pkg-config gnutls-bin sudo vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y libmysqld-dev && rm -rf /var/lib/apt/lists/*;

# install go1.13.5
RUN wget https://dl.google.com/go/go1.13.5.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.13.5.linux-amd64.tar.gz && rm go1.13.5.linux-amd64.tar.gz
RUN mkdir $HOME/go
ENV PATH $PATH:/usr/local/go/bin
ENV GOPATH $HOME/go
RUN echo "export GOPATH=$HOME/go" >> ~/.bashrc
RUN echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bashrc
RUN echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
RUN echo "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" >> ~/.bashrc

# intall openssl 1.1.1d
RUN wget https://www.openssl.org/source/openssl-1.1.1d.tar.gz
RUN tar -C $HOME -xzf openssl-1.1.1d.tar.gz && rm openssl-1.1.1d.tar.gz
WORKDIR $HOME/openssl-1.1.1d
RUN ./config -Wl,--enable-new-dtags,-rpath,'$(LIBRPATH)' --prefix=/usr/local
RUN make && make install
RUN echo '/usr/local/lib' >> /etc/ld.so.conf

# install libcoap
WORKDIR $HOME
RUN git clone https://github.com/obgm/libcoap.git
WORKDIR $HOME/libcoap
RUN git checkout 6fc3a7315f6629d804cc7928004cddeb4a84443c
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-documentation --with-openssl
RUN make && make install
RUN ldconfig

# install go-dots
WORKDIR $HOME
RUN go get -u github.com/nttdots/go-dots/...
WORKDIR $GOPATH/src/github.com/nttdots/go-dots/
RUN make && make install

