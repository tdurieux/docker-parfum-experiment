FROM ubuntu:16.04



RUN apt update && apt install --no-install-recommends -y \
	xz-utils \
	git \
	wget \
	ca-certificates \
	gzip \
	tar \
	ssh \
	build-essential \
	curl \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -f -SL https://releases.llvm.org/6.0.0/clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz \
	| tar -xJC . && \
	mv clang+llvm-6.0.0-x86_64-linux-gnu-ubuntu-16.04 clang_6.0.0


ENV PATH /clang_6.0.0/bin:$PATH
ENV LD_LIBRARY_PATH /clang_6.0.0/lib:LD_LIBRARY_PATH


RUN mkdir /goroot && curl -f https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz | tar xvzf - -C /goroot --strip-components=1
RUN mkdir /go

ENV GOROOT /goroot
ENV GOPATH /go
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

WORKDIR /go/src/github.com/geode-lang/geode


CMD ["/bin/bash"]

