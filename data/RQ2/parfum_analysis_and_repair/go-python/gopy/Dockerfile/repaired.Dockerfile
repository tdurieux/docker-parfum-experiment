FROM golang:onbuild
RUN apt-get update && apt-get install --no-install-recommends -y pkg-config python2.7-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;
CMD /go/bin/app
