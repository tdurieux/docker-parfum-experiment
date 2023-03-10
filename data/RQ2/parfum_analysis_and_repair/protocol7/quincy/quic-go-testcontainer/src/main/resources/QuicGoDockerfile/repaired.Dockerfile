FROM golang:1.14.5

ARG hash=d1c5297c0bd9176e5f76e4245a1bcb2fe51bed2a

WORKDIR /root/src/github.com/lucas-clemente/quic-go

RUN git clone https://github.com/lucas-clemente/quic-go.git . && git checkout $hash

RUN go get -d -v ./...

COPY main.go interop/main.go

EXPOSE 6121/udp

ENTRYPOINT ["go", "run", "interop/main.go"]