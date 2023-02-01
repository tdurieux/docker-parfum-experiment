FROM golang:latest

WORKDIR /go/src/app
COPY . .

RUN apt-get update && apt-get --assume-yes -y --no-install-recommends install dmz-cursor-theme fonts-dejavu libxkbcommon-dev libx11-data && rm -rf /var/lib/apt/lists/*;
RUN go get -d -v ./...
RUN go install -v ./go-wayland-simple-shm
RUN go install -v ./go-wayland-smoke
RUN go install -v ./go-wayland-imageviewer

