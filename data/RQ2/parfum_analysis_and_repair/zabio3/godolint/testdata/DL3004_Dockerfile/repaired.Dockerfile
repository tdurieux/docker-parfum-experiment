FROM ubuntu:1.12.0-stretch

RUN sudo apt-get install -y

WORKDIR /go
COPY . /go

CMD ["go", "run", "main.go"]