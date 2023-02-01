FROM armhf/alpine:edge
RUN apk add --update musl-dev gcc go git mercurial bash wget ca-certificates
RUN mkdir -p /go/src/github.com/kpmy/mipfs
COPY . /go/src/github.com/kpmy/mipfs
ENV GOPATH /go
RUN go get -v github.com/kpmy/mipfs/dav_multiuser_cmd
RUN go install github.com/kpmy/mipfs/dav_multiuser_cmd
RUN mkdir -p /go/.diskv
RUN printf "ipfs:5001" > /go/.diskv/ipfs
COPY ./dav_multiuser_cmd/.diskv/* /go/.diskv/
EXPOSE 6001
WORKDIR /go
CMD /go/bin/dav_multiuser_cmd