FROM library/golang
WORKDIR /floop
ENV GOPATH /floop
CMD go test -v hello 