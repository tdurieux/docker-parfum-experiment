FROM golang:1.14-alpine
RUN apk add --no-cache go git musl-dev iptables tmux bind-tools curl sudo python3
