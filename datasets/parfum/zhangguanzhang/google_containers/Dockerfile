#https://basefas.github.io/2019/09/24/%E4%BD%BF%E7%94%A8%20Docker%20%E6%9E%84%E5%BB%BA%20Go%20%E5%BA%94%E7%94%A8/
FROM golang:1.15.6 as mod
LABEL stage=mod
ARG GOPROXY=https://goproxy.cn,https://mirrors.aliyun.com/goproxy/,https://goproxy.io,direct
WORKDIR /root/myapp/

COPY go.mod ./
COPY go.sum ./
RUN go mod download

FROM mod as builder
LABEL stage=intermediate0
ARG LDFLAGS
COPY ./ ./
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o imgsync -tags=containers_image_openpgp -ldflags "${LDFLAGS}" main.go


FROM alpine:3.11.6
WORKDIR /root
COPY --from=builder /root/myapp/imgsync /imgsync
ENTRYPOINT ["/imgsync"]
