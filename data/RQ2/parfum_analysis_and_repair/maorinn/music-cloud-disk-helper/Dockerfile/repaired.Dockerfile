FROM golang:1.17.2 AS golang_builder
ENV GOPROXY=https://goproxy.cn,direct
ENV ROOT=/app
ENV CGO_ENABLED 0
RUN mkdir -p ${ROOT}
COPY . ${ROOT}
WORKDIR ${ROOT}/server/cmd/app
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o go_server

FROM node:14
ENV ROOT=/app
WORKDIR ${ROOT}
COPY --from=golang_builder ${ROOT}/* /app/
WORKDIR ${ROOT}/clinet
ENV NODE_ENV=production
RUN npm install && npm cache clean --force;
RUN npm i -g serve && npm cache clean --force;
RUN npm run build
EXPOSE 3000
EXPOSE 22333
# 复制打包的Go文件到系统用户可执行程序目录下
COPY --from=golang_builder ${ROOT}/server/cmd/app/go_server /app
WORKDIR ${ROOT}
RUN chmod +x go_server
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
# FROM alpine:3.7
# # 配置国内源
# RUN echo "http://mirrors.aliyun.com/alpine/v3.7/main/" > /etc/apk/repositories
# RUN apk update
# RUN apk add ca-certificates
# # dns
# RUN echo "hosts: files dns" > /etc/nsswitch.conf
# RUN mkdir -p ${ROOT}

# WORKDIR ${ROOT}

