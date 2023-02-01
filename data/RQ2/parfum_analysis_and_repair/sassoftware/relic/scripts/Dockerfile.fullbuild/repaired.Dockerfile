FROM fedora:30
WORKDIR /scratch
RUN dnf install -y wget git gcc mingw64-gcc
ARG goversion
RUN wget -q https://dl.google.com/go/go${goversion}.linux-amd64.tar.gz && tar -xf go*.tar.gz -C /opt && rm go*.tar.gz
ENV PATH=/opt/go/bin:/usr/bin:/usr/sbin

WORKDIR /src
ENV GO111MODULE=on CGO_ENABLED=1
ARG GOPROXY
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN mkdir /out
ARG ldflags
RUN GOOS=linux   GOARCH=amd64 CC=x86_64-redhat-linux-gcc go build -ldflags "$ldflags" -o /out/relic-linux-amd64
RUN GOOS=windows GOARCH=amd64 CC=x86_64-w64-mingw32-gcc  go build -ldflags "$ldflags" -o /out/relic-windows-amd64.exe
