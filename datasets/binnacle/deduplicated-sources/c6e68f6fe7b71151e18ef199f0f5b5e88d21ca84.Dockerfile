FROM golang:1.5.1

RUN go get  github.com/golang/lint/golint \
            github.com/mattn/goveralls \
            golang.org/x/tools/cover \
            github.com/tools/godep \
            github.com/aktau/github-release

WORKDIR /go/src/github.com/hypriot/docker-machine-hypriot

ADD . /go/src/github.com/hypriot/docker-machine-hypriot
