FROM golang:latest

VOLUME /out
# adduser?

COPY build.sh /
CMD /build.sh