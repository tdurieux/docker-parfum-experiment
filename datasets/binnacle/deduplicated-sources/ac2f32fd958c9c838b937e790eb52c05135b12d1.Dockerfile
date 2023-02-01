FROM golang:1.6

RUN apt-get update && apt-get install -yq --no-install-recommends patch bzip2

# enable faketime
ADD enable-fake-time.patch /usr/local/go/
RUN patch /usr/local/go/src/runtime/rt0_nacl_amd64p32.s /usr/local/go/enable-fake-time.patch

# add fake file system
ADD fake_fs.lst /usr/local/go/
RUN cd /usr/local/go && go run misc/nacl/mkzip.go -p syscall fake_fs.lst src/syscall/fstest_nacl.go

# Install go1.4 ss $HOME/go1.4 (the default location), as we need it to build
# Go 1.5+. We can't just use the existing Go installation to bootstrap, as the
# first thing make.bash does is clean the existing binaries.
RUN curl https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz | tar -xz -C /root && mv /root/go /root/go1.4

# Build the Go nacl tool chain.
RUN cd /usr/local/go/src && GOOS=nacl GOARCH=amd64p32 ./make.bash --no-clean
RUN curl -s https://storage.googleapis.com/nativeclient-mirror/nacl/nacl_sdk/44.0.2403.157/naclsdk_linux.tar.bz2 | tar -xj -C /usr/local/bin --strip-components=2 pepper_44/tools/sel_ldr_x86_64

# add and compile tour packages
RUN GOOS=nacl GOARCH=amd64p32 go get \
	golang.org/x/tour/pic \
	golang.org/x/tour/reader \
	golang.org/x/tour/tree \
	golang.org/x/tour/wc \
	golang.org/x/talks/2016/applicative/google

# add tour packages under their old import paths (so old snippets still work)
RUN mkdir -p $GOPATH/src/code.google.com/p/go-tour && \
	cp -R $GOPATH/src/golang.org/x/tour/* $GOPATH/src/code.google.com/p/go-tour/ && \
	sed -i 's_// import_// public import_' $(find $GOPATH/src/code.google.com/p/go-tour/ -name *.go) && \
	go install \
		code.google.com/p/go-tour/pic \
		code.google.com/p/go-tour/reader \
		code.google.com/p/go-tour/tree \
		code.google.com/p/go-tour/wc

# add and compile sandbox daemon
ADD . /go/src/sandbox/
RUN go install sandbox

# make sure it works
RUN /go/bin/sandbox test

EXPOSE 8080
ENTRYPOINT ["/go/bin/sandbox"]
