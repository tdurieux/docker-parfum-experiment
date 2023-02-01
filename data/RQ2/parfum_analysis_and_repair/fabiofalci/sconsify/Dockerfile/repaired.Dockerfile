FROM ubuntu:18.04

RUN apt-get update && apt-get install -y curl build-essential git mercurial portaudio19-dev ca-certificates gnupg --no-install-recommends && rm -rf /var/lib/apt/lists/*;

# Libspotify
RUN curl -f https://apt.mopidy.com/mopidy.gpg | apt-key add - && curl -f -o /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/mopidy.list
RUN apt-get update && apt-get install --no-install-recommends -y libspotify-dev && rm -rf /var/lib/apt/lists/*;

# Install Go
RUN curl -f -sSL https://storage.googleapis.com/golang/go1.15.3.linux-amd64.tar.gz | tar -v -C /usr/local -xz
ENV PATH /usr/local/go/bin:$PATH
ENV GOPATH /go

WORKDIR /go/src/github.com/fabiofalci/sconsify

# Upload sconsify source
COPY . /go/src/github.com/fabiofalci/sconsify

ENV PATH=$PATH:$GOPATH/bin
