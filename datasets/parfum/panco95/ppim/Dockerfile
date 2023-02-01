FROM golang:1.16.6
WORKDIR /go/src/ppim
COPY . .
RUN chmod +x /go/src/ppim/env/wait
RUN go env -w GOPROXY=https://goproxy.cn,direct \
 && go mod tidy
CMD /go/src/ppim/env/wait && go run cmd/run/main.go