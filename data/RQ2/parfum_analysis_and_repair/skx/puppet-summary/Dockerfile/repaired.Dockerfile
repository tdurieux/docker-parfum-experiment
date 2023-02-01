# First build puppet-summary
FROM alpine
RUN apk --no-cache add go git musl-dev
RUN go get -u github.com/skx/puppet-summary

# Now put it in a container without all the build tools