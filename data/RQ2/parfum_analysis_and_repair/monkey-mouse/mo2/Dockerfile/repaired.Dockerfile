#build stage
FROM golang:1.16 AS builder
RUN apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;
WORKDIR /go/src/app
ENV GOPROXY=https://goproxy.cn,direct
COPY . .
RUN go get -d -v ./...
RUN go install -v ./...
COPY . /go/bin



#final stage
FROM ubuntu:latest
RUN apt-get update
RUN apt-get install --no-install-recommends ca-certificates -y && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
RUN chmod -R 777 .
COPY --from=builder /go/bin /app
ENV GIN_MODE=release
ENV MO2_MONGO_URL=mongodb://mongodb:27017
ENV REDIS_URL=redis:6379
ENTRYPOINT /app/mo2
LABEL Name=mo2 Version=0.0.1
EXPOSE 5001
