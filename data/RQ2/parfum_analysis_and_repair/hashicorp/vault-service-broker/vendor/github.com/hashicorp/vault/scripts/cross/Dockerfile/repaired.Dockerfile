FROM debian:testing

RUN apt-get update -y && apt-get install --no-install-recommends -y -q \
                         curl \
                         zip \
                         build-essential \
                         gcc-multilib \
                         g++-multilib \
                         ca-certificates \
                         git mercurial bzr \
                         gnupg \
                         libltdl-dev \
                         libltdl7 && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /var/lib/apt/lists/*

RUN npm install -g yarn@1.12.1 && npm cache clean --force;

ENV GOVERSION 1.11.4
RUN mkdir /goroot && mkdir /gopath
RUN curl -f https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz \
           | tar xvzf - -C /goroot --strip-components=1

ENV GOPATH /gopath
ENV GOROOT /goroot
ENV PATH $GOROOT/bin:$GOPATH/bin:$PATH

RUN go get github.com/mitchellh/gox
RUN go get github.com/hashicorp/go-bindata
RUN go get github.com/hashicorp/go-bindata/go-bindata
RUN go get github.com/elazarl/go-bindata-assetfs
RUN go get github.com/elazarl/go-bindata-assetfs/go-bindata-assetfs

RUN mkdir -p /gopath/src/github.com/hashicorp/vault
WORKDIR /gopath/src/github.com/hashicorp/vault
CMD make static-dist bin
