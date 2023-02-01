FROM golang:1.12 AS compiler

WORKDIR $GOPATH/src/github.com/msoedov/hacker-slides

ENV GO111MODULE on
RUN go mod download

COPY . .
RUN GOOS=linux CGO_ENABLE=0 go build  -a -tags netgo -ldflags '-w -extldflags "-static"' -o /bin/app *.go



FROM alpine:3.8

WORKDIR /srv

ENV GIN_MODE=release
RUN mkdir slides
COPY --from=compiler /bin/app /bin/app
COPY static static
COPY templates templates
COPY initial-slides.md initial-slides.md
CMD app $PORT