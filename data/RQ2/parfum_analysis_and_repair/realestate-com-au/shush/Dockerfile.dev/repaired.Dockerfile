FROM golang:1.16

ENV CGO_ENABLED=0
WORKDIR /go/src/github.com/realestate-com-au/shush
COPY . /go/src/github.com/realestate-com-au/shush
RUN go mod vendor

CMD ["bash"]