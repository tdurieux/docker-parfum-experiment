# First, build
FROM golang:1.12 as builder
WORKDIR /go/src/github.com/parkr/jekyll-build-server
ADD . .
RUN go version
RUN CGO_ENABLED=0 GOOS=linux go install github.com/parkr/jekyll-build-server/...

# We're using Jekyll, so the resulting Docker image is built with Ruby installed.
FROM ruby:2.6
COPY --from=builder /go/bin/jekyll-build-server /bin/jekyll-build-server
RUN apt-get update && apt-get install --no-install-recommends -y nodejs locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
CMD ["/bin/jekyll-build-server"]
