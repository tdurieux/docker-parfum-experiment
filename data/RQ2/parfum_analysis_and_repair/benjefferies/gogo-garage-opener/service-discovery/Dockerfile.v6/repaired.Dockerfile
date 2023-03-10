FROM benjjefferies/golang-armv6l as builder

# The command to use to compile C code.
ENV CC arm-linux-gnueabihf-gcc
# The command to use to compile C++ code.
ENV CXX=arm-linux-gnueabihf-g++
# The OS running on the raspberry pi
ENV GOOS linux
# The CPU architecture of the raspberry pi
ENV GOARCH arm
ENV GOARM 6
# Cgo enables the creation of Go packages that call C code. (required for https://github.com/mattn/go-sqlite3)
ENV CGO_ENABLED 1

ADD . /work/go/src/github.com/benjefferies/gogo-garage-opener/service-discovery

WORKDIR /work/go/src/github.com/benjefferies/gogo-garage-opener/service-discovery

RUN go get -d -v ./... && \
  go install -v ./...

FROM arm32v6/alpine

WORKDIR /var/gogo-garage-opener

COPY --from=builder /work/go/bin/service-discovery /var/gogo-garage-opener/service-discovery

RUN apk add --no-cache libc6-compat

CMD [ "./service-discovery" ]
