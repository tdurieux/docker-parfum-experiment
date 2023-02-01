FROM ubuntu:16.04

WORKDIR /root/

RUN apt update -y && apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository ppa:ubuntu-toolchain-r/test

RUN apt update -y && apt-get -y --no-install-recommends install autoconf libtool pkg-config git flex bison libsctp-dev libgnutls28-dev libgcrypt-dev libssl-dev libidn11-dev libmongoc-dev libbson-dev libyaml-dev wget gcc-7 iptables && rm -rf /var/lib/apt/lists/*;

RUN wget https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.11.4.linux-amd64.tar.gz && rm go1.11.4.linux-amd64.tar.gz
ENV GOROOT /usr/local/go
ENV GOPATH /root/go
ENV PATH $PATH:/usr/local/go/bin

RUN go get -u -v "github.com/gorilla/mux"
RUN go get -u -v "golang.org/x/net/http2"
RUN go get -u -v "golang.org/x/sys/unix"

RUN git clone https://bitbucket.org/nctu_5g/free5gc-stage-1 free5gc
WORKDIR /root/free5gc

RUN autoreconf -iv
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=`pwd`/install
RUN make -j `nproc`
RUN make install

RUN rm -rf /root/free5gc/install/etc/free5gc/*.conf && rm -rf /root/free5gc/install/etc/free5gc/freeDiameter/*.conf

RUN grep -r "mongodb://localhost" | awk -F : '{print $1}' | xargs -i sed -i 's/localhost/mongodb-svc/g' {}

RUN git clone https://github.com/free5gmano/kube5gc && cp kube5gc/docker/setup-uptun.sh setup-uptun.sh
