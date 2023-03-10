FROM golang:1.7.5

ENV workdir /app
RUN mkdir -p $workdir
WORKDIR $workdir

RUN git clone https://github.com/18F/cg-fake-uaa.git
WORKDIR $workdir/cg-fake-uaa


RUN go get -d ./...
RUN go get -u github.com/jteeuwen/go-bindata/...

RUN go generate
RUN go build

CMD ./cg-fake-uaa --callback-url http://0.0.0.0:3000/auth/cg/callback