FROM golang:1.15 AS build
WORKDIR /project/agent
COPY . ./
RUN go test -cover ./...

ENV CGO_ENABLED=0
RUN go build -a -installsuffix cgo -o mysql-agent .

FROM mysql:8.0.22
RUN apt update && \
    apt install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
COPY --from=build /project/agent/mysql-agent ./
EXPOSE 8080/tcp
ENTRYPOINT ["./mysql-agent"]
