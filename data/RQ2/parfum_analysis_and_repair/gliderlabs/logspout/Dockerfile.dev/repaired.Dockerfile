FROM alpine:3.12
VOLUME /mnt/routes
EXPOSE 80

RUN apk --no-cache add go build-base git mercurial ca-certificates curl
COPY . /src
WORKDIR /src
CMD go build -ldflags "-X main.Version=dev" -o /bin/logspout \
		&& exec /bin/logspout