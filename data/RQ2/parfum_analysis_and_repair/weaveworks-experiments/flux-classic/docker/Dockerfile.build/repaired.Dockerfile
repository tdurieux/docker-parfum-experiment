FROM krallin/ubuntu-tini:trusty

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]

# Borrowed from <https://github.com/docker-library/golang/blob/master/1.5/Dockerfile>

# gcc for cgo
RUN apt-get update && apt-get install -y --no-install-recommends \
		curl \
		g++ \
		gcc \
		libc6-dev \
		make \
                git mercurial \
	&& rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.5.1
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA1 46eecd290d8803887dec718c691cc243f2175fe0

RUN curl -fsSLk "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& echo "$GOLANG_DOWNLOAD_SHA1  golang.tar.gz" | sha1sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

# End borrowings

ENV CGO_ENABLED=0
RUN go install std