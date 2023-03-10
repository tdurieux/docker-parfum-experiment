FROM benjjefferies/golang-armv6l as builder

# The command to use to compile C code.
ENV CC arm-linux-gnueabihf-gcc
# The command to use to compile C++ code.
ENV CXX=arm-linux-gnueabihf-g++
# The command to use to compile C++ code.
ENV CXX=arm-linux-gnueabihf-g++
# The OS running on the raspberry pi
ENV GOOS linux
# The CPU architecture of the raspberry pi
ENV GOARCH arm
ENV GOARM 6
# Cgo enables the creation of Go packages that call C code. (required for https://github.com/mattn/go-sqlite3)
ENV CGO_ENABLED 1

ADD . /work/go/src/github.com/benjefferies/gogo-garage-opener

WORKDIR /work/go/src/github.com/benjefferies/gogo-garage-opener

RUN go get -d -v ./...
RUN go install -v ./...

FROM arm32v6/alpine

WORKDIR /var/gogo-garage-opener

COPY --from=builder /work/go/bin/gogo-garage-opener /var/gogo-garage-opener/gogo-garage-opener
COPY gogo-garage-opener/index.html /var/gogo-garage-opener/index.html

RUN apk add --no-cache libc6-compat

CMD [ "./gogo-garage-opener" ]
