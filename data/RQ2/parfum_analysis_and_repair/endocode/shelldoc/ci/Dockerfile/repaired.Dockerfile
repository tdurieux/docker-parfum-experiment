FROM golang:1.12
LABEL	maintainer="Mirko Boehm <mirko@endocode.com>"
ENV	LC_ALL C.UTF-8
ENV	LANG C.UTF-8
RUN apt-get update && apt-get -yqq --no-install-recommends install python3 golang git libxml2-utils bash && rm -rf /var/lib/apt/lists/*;
ENV	SHELL /bin/bash
RUN	go get -u github.com/jstemmer/go-junit-report
ADD	. /shelldoc

