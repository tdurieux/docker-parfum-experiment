FROM golang:stretch AS build
RUN apt-get update && apt-get install --no-install-recommends git -y && go get github.com/go-martini/martini && rm -rf /var/lib/apt/lists/*;
RUN mkdir /build
ADD . /build/
WORKDIR /build
RUN go build -o app .

FROM ubuntu:latest AS final
RUN apt-get update && apt-get install --no-install-recommends iputils-ping curl -y && rm -rf /var/lib/apt/lists/*;
COPY --from=build /build/app /app/
WORKDIR /app
CMD ["./app"]