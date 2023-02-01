# build stage
FROM golang:1.14 AS build-env
WORKDIR /go/src/app
COPY . .
RUN go get -d -v ./...
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/bin/worldapi

# final stage
FROM ubuntu:18.04
COPY --from=build-env /go/bin/worldapi /go/bin/worldapi
COPY --from=build-env /go/src/app/images /go/bin/images
COPY --from=build-env /go/src/app/data /go/bin/data
RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends ca-certificates -y && rm -rf /var/lib/apt/lists/*;
EXPOSE 7531
CMD ["/go/bin/worldapi"]
