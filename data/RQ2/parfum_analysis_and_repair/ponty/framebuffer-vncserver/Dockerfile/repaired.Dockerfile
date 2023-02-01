FROM alpine as builder
LABEL maintainer="ek5.chimenti@gmail.com"

ADD . /target/
WORKDIR /target

RUN apk fetch
RUN apk add --no-cache libvncserver-dev
RUN apk add --no-cache gcc g++ cmake make linux-headers

RUN mkdir -p build
WORKDIR /target/build
RUN cmake ..
RUN make

FROM alpine

COPY --from=builder /target/build/framebuffer-vncserver /usr/bin
RUN apk update && apk add --no-cache libvncserver

ENTRYPOINT [ "framebuffer-vncserver" ]
