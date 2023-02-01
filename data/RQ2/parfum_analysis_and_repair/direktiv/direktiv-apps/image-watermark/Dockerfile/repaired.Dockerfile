FROM golang:1.15-buster as build

WORKDIR /app
COPY ./main.go ./
COPY ./go.mod ./
COPY ./go.sum ./
RUN go get -u -v
RUN CGO_ENABLED=0 go build -o /watermark -ldflags="-s -w" main.go

FROM ubuntu:latest as ttf
RUN apt-get update && apt-get install --no-install-recommends -y fonts-liberation && rm -rf /var/lib/apt/lists/*;

FROM scratch
COPY --from=build /watermark /
COPY --from=ttf /usr/share/fonts/truetype/liberation/LiberationMono-Regular.ttf /usr/share/fonts/truetype/liberation/LiberationMono-Regular.ttf
CMD ["/watermark"]
