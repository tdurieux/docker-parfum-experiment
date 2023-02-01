FROM golang:1.17

RUN apt update && apt install --no-install-recommends -y unzip time make protobuf-compiler && rm -rf /var/lib/apt/lists/*;

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest

ADD . /go/src/github.com/tilt-dev/servantes/fortune
RUN cd /go/src/github.com/tilt-dev/servantes/fortune && make proto
RUN cd /go/src/github.com/tilt-dev/servantes/fortune && go install .

ENTRYPOINT /go/bin/fortune
