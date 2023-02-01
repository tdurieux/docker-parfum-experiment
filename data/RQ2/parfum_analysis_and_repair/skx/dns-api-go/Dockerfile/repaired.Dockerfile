# First build the application
FROM alpine
RUN apk --no-cache add go git musl-dev
RUN go get -u github.com/skx/dns-api-go

# Now put it in a container without all the build tools