FROM golang:1.15

RUN mkdir -p /go/src/github.com/rpip/paystack-go
WORKDIR /go/src/github.com/rpip/paystack-go
ENV GOPATH /go

RUN go get golang.org/x/tools/cover 
RUN go get golang.org/x/lint/golint

COPY . /go/src/github.com/rpip/paystack-go

CMD ["./runtests.sh"]