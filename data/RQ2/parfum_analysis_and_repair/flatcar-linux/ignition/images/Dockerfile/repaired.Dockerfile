# Used in the Jenkins environment

FROM golang:_GOVERSION_

RUN echo "deb http://deb.debian.org/debian stretch main" >> /etc/apt/sources.list

# gcc for cgo