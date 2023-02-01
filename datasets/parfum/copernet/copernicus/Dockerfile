FROM copernet/copernicus:basic

WORKDIR /
RUN git clone https://github.com/copernet/secp256k1.git
WORKDIR /secp256k1
RUN ./autoinstall.sh
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/secp256k1.conf && ldconfig

RUN curl https://glide.sh/get | sh
RUN go get golang.org/x/tools/cmd/cover
RUN go get github.com/mattn/goveralls

WORKDIR /go/src/github.com/copernet
COPY ./ /go/src/github.com/copernet/copernicus
WORKDIR /go/src/github.com/copernet/copernicus
RUN glide install
RUN go get -u github.com/alecthomas/gometalinter
RUN gometalinter --install
RUN go build
RUN go install

WORKDIR /
RUN git clone https://github.com/copernet/walle.git
RUN cp $GOPATH/bin/copernicus /walle
WORKDIR /walle
RUN mkdir .venv
RUN pipenv --python 3.7
RUN pipenv install

WORKDIR /



