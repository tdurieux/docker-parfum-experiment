FROM golang:1.17-buster

RUN apt-get update && \
    apt-get install --no-install-recommends -y mariadb-client && rm -rf /var/lib/apt/lists/*;

ADD . /go/src/github.com/google/trillian
WORKDIR /go/src/github.com/google/trillian

# This is used to wait for new MySQL deployments to become ready e.g.
#  ./wait-for-it.sh localhost:3306 -- mysql
RUN ./examples/deployment/scripts/download-wait-for-it.sh

CMD [ 'mysql' ]
