FROM golang:1.14-alpine as go-build
RUN apk --update --no-cache add musl-dev
RUN apk --update --no-cache add util-linux-dev
RUN apk --update --no-cache add gcc g++
WORKDIR /go/src/github.com/covergates/covergates
COPY . .
RUN CGO_ENABLED=1 GOOS=linux go build -v -o covergates ./cmd/server
FROM alpine
COPY --from=go-build /go/src/github.com/covergates/covergates/covergates /covergates
ENTRYPOINT [ "/covergates" ]
