FROM alpine

ENV GOPROXY https://goproxy.cn
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
WORKDIR /app
RUN apk update && apk --no-cache add ca-certificates curl vim python2 python3 nodejs npm go
COPY crocodile-linux-amd64 crocodile
CMD ["/app/crocodile","client","-c","core.toml"]

# docker build -t labulaka522/crocodile_worker . -f Dockerfile.worker
# docker run -v $PWD/core.toml:/app/core.toml labulaka522/crocodile:worker