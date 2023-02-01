FROM alpine

WORKDIR /app
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
COPY crocodile-linux-amd64 crocodile
CMD ["/app/crocodile","server","-c","core.toml"]

# docker build -t labulaka522/crocodile . -f Dockerfile
# docker run -p 8080:8080 -v $PWD/core.toml:/app/core.toml labulaka521/crocodile