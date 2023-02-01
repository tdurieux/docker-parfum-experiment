FROM alpine:latest
MAINTAINER Andrew Dunham <andrew@du.nham.ca>

RUN apk --update --no-cache add build-base bash automake git curl linux-headers

RUN mkdir /build
RUN mkdir /output
ADD . /build

# This builds the program and copies it to /output
CMD /build/build.sh
