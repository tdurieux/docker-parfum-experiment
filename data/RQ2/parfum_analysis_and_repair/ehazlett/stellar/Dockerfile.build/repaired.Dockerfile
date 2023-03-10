FROM golang:1.11-alpine AS build

ARG GOOS
ARG GOARCH
RUN apk add --no-cache -U git make curl build-base bash git autoconf automake libtool unzip file bzr
RUN git clone https://github.com/google/protobuf /tmp/protobuf && \
    cd /tmp/protobuf && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install
RUN go get -v github.com/LK4D4/vndr
RUN go get -v github.com/golang/protobuf/protoc-gen-go
RUN go get -v github.com/gogo/protobuf/protoc-gen-gofast
RUN go get -v github.com/gogo/protobuf/proto
RUN go get -v github.com/gogo/protobuf/gogoproto
RUN go get -v github.com/gogo/protobuf/protoc-gen-gogo
RUN go get -v github.com/gogo/protobuf/protoc-gen-gogofast
RUN go get -v github.com/stevvooe/protobuild
RUN go get -v golang.org/x/lint/golint
RUN go get -v github.com/tebeka/go2xunit
ENV APP stellar
ENV REPO ehazlett/$APP
ARG BUILD
COPY . /go/src/github.com/$REPO
WORKDIR /go/src/github.com/$REPO
RUN make

FROM scratch
COPY --from=build /go/src/github.com/ehazlett/stellar/bin /
