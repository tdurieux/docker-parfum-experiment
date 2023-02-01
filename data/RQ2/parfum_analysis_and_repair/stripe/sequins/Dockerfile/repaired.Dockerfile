FROM golang:1.8.3

RUN apt-get update && apt-get install --no-install-recommends -y build-essential autoconf libtool pkg-config && rm -rf /var/lib/apt/lists/*;

ADD . /go/src/github.com/stripe/sequins
RUN mkdir -p /build/
WORKDIR /go/src/github.com/stripe/sequins
CMD /go/src/github.com/stripe/sequins/jenkins_build.sh
