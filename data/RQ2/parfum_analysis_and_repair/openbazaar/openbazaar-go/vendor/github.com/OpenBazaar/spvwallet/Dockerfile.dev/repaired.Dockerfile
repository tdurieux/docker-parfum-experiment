FROM golang:1.11
VOLUME /var/lib/openbazaar

WORKDIR /go/src/github.com/OpenBazaar/spvwallet
RUN curl -f https://raw.githubusercontent.com/golang/dep/master/install.sh | sh && \
		go get -u github.com/derekparker/delve/cmd/dlv

COPY . .

ENTRYPOINT ["/bin/bash"]
