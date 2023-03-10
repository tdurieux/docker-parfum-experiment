FROM golang:1.6
ENV ETHTOOL ethtool-3.16
RUN wget https://www.kernel.org/pub/software/network/ethtool/$ETHTOOL.tar.gz
RUN tar -xvzf $ETHTOOL.tar.gz && rm $ETHTOOL.tar.gz
RUN cd $ETHTOOL && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" LDFLAGS=-static && make && cp ethtool /go/
