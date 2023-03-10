FROM golang:latest
MAINTAINER Andreas Koch <andy@allmark.io>

# Install pandoc for RTF conversion
RUN apt-get update && apt-get install --no-install-recommends -qy pandoc && rm -rf /var/lib/apt/lists/*;

# Build
ADD . /go
RUN make install
RUN make crosscompile

# Data
RUN mkdir /data
ADD . /data

VOLUME ["/data"]

CMD ["/go/bin/allmark", "serve", "/data"]
