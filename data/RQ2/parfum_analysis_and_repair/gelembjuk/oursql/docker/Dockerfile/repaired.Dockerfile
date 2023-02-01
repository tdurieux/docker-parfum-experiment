FROM ubuntu:latest
MAINTAINER Roman Gelembjuk

# Install latest updates
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y gcc make && \
    apt-get install --no-install-recommends -y golang-1.10 && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install mysql-client mysql-server && \
    apt-get install --no-install-recommends -y iproute2 git && rm -rf /var/lib/apt/lists/*;

ENV GOPATH="/build/"
ENV PATH="/usr/lib/go-1.10/bin:${PATH}"

RUN go get -u github.com/JamesStewy/go-mysqldump &&\
    go get -u github.com/go-sql-driver/mysql && \
    go get -u github.com/btcsuite/btcutil &&\
    go get -u github.com/fatih/structs &&\
    go get -u github.com/mitchellh/mapstructure

ADD . /build/src/github.com/gelembjuk/oursql/

# Compile
RUN cd /build/src/github.com/gelembjuk/oursql/node &&\
    CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo . &&\
    cp node /node

# Create temp file to know about the first start of a container
RUN touch firststart.lock

# Set Standard settings
ENV DBNAME BC
ENV DBUSER blockchain
ENV DBPASSWORD blockchain

ADD docker/conf/ /conf

ADD docker/run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

ADD docker/healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod +x /usr/local/bin/healthcheck.sh

HEALTHCHECK CMD /usr/local/bin/healthcheck.sh

EXPOSE 8765
EXPOSE 8766

ENTRYPOINT ["/usr/local/bin/run.sh"]
CMD ["interactiveautocreate"]
