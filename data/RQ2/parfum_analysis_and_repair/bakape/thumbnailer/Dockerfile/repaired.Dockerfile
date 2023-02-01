FROM ubuntu:focal

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
	build-essential \
	pkg-config \
	curl \
	libavcodec-dev \
	libavutil-dev \
	libavformat-dev \
	libswscale-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get dist-upgrade -y









# Install Go
RUN curl -f -s \
	"https://dl.google.com/go/$( curl -f -s https://golang.org/VERSION?m=text).linux-amd64.tar.gz" \
	| tar xpz -C /usr/local
ENV PATH=$PATH:/usr/local/go/bin

# Try to cache deps
COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
