FROM golang:latest
WORKDIR /myapp
COPY welcome.go .
RUN go build -o welcome .
ENTRYPOINT ["./welcome"]

