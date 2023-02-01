FROM golang:1.10

RUN apt-get update && \
    apt-get install --no-install-recommends -y \

      build-essential \

      curl \

      git \

      awscli && rm -rf /var/lib/apt/lists/*;

# install dep (not using it yet, but probably will switch to it)
RUN curl -f https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

# setup the app dir/working directory
RUN mkdir -p /go/src/github.com/nanopack/logvac
WORKDIR /go/src/github.com/nanopack/logvac

# copy the source
COPY . .

# fetch deps
RUN make deps
