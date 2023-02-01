FROM jenkins/jnlp-slave

USER root

RUN apt-get update && \
    apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;

RUN curl -f -o gsutil.tar.gz https://storage.googleapis.com/pub/gsutil.tar.gz; \
    tar -xzf gsutil.tar.gz -C /opt && rm gsutil.tar.gz

ENV PATH /opt/gsutil:$PATH

# gcc for cgo
RUN apt-get update && apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
		make \
		pkg-config \
	&& rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.12.7

RUN \
	url="https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz"; \
	wget -O go.tgz "$url"; \
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; \
	export PATH="/usr/local/go/bin:$PATH"; \
	go version

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH
