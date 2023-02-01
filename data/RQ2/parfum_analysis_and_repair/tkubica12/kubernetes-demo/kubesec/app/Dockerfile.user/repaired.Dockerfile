FROM golang:stretch AS build
RUN apt-get update && apt-get install --no-install-recommends git -y && go get github.com/go-martini/martini && rm -rf /var/lib/apt/lists/*;
RUN mkdir /build
ADD . /build/
WORKDIR /build
RUN go build -o app .

FROM ubuntu:latest AS final
RUN groupadd -r standardgroup && useradd --no-log-init -u 12000 -r -g standardgroup standarduser
RUN apt-get update && apt-get install --no-install-recommends iputils-ping curl -y && rm -rf /var/lib/apt/lists/*;
USER standarduser
COPY --chown=standarduser:standardgroup --from=build /build/app /app/
WORKDIR /app
CMD ["./app"]