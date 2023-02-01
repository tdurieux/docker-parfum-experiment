FROM golang:1.10

RUN apt-get update && apt-get -y --no-install-recommends install curl g++ make bzip2 nano unixodbc unixodbc-dev mysql-client && rm -rf /var/lib/apt/lists/*;

WORKDIR /go/src/horgh-replicator
COPY . .

COPY files/vertica-client-7.2.0-0.x86_64.tar.gz /vertica-client.tar.gz
RUN tar -xvf /vertica-client.tar.gz -C / && rm /vertica-client.tar.gz

#installing dep and vendors
RUN go get -u github.com/golang/dep/...

CMD ["sh", "-c", "cd /go/src/horgh-replicator/src && dep ensure -update && /bin/bash"]
