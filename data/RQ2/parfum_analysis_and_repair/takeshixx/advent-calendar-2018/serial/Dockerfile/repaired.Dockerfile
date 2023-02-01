FROM ubuntu:18.04

RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;


# Install Go-Lang
run wget https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz && \
	tar -C /usr/local -xzf go1.11.2.linux-amd64.tar.gz && rm go1.11.2.linux-amd64.tar.gz

ENV PATH $PATH:/usr/local/go/bin
ENV GOPATH /root/go
ENV PATH $PATH:/usr/local/go/bin

WORKDIR /usr/src/app
COPY serial.go .
COPY success .

EXPOSE 6
EXPOSE 666
CMD ["go", "run", "serial.go"]
