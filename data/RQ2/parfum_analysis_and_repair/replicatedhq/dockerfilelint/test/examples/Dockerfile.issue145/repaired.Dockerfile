# we set this here because buildx normally sets it for us, but
# CircleCI doesn't support a new enough docker, so we have to
# pass this arg manually when in CI
# ARG BUILDPLATFORM

# Run tests stage (we only run this on the BUILDPLATFORM)
FROM --platform=$BUILDPLATFORM golang:alpine3.12 as test

WORKDIR /go/src/github.com/iggy/scurvy/

RUN apk add --no-cache git upx gcc libc-dev

RUN go get -u golang.org/x/lint/golint \
	honnef.co/go/tools/cmd/staticcheck \
	github.com/fzipp/gocyclo

# Use add here to invalidate the cache
ADD . /go/src/github.com/iggy/scurvy/

# install deps the easy way
RUN go get github.com/iggy/scurvy/...

# These are all separate so failures are a little easier to track
RUN gofmt -l -s -w ./cmd ./pkg
# RUN test -z $(gofmt -s -l $GO_FILES)
# go test -race basically doesn't work with alpine/musl
# RUN go test -v -race ./...
RUN go vet ./...
RUN staticcheck ./...
# RUN gocyclo -over 19 $GO_FILES
RUN golint -set_exit_status $(go list ./...)



# Build binaries stage (we only run this on the BUILDPLATFORM)
FROM --platform=$BUILDPLATFORM golang:alpine3.12 as build

WORKDIR /go/src/github.com/iggy/scurvy/

RUN apk add --no-cache git upx gcc libc-dev

RUN go get -u github.com/mitchellh/gox \
	github.com/tcnksm/ghr

# Use add here to invalidate the cache
ADD . /go/src/github.com/iggy/scurvy/

# install deps the easy way
RUN go get github.com/iggy/scurvy/...

# build the binaries
# release binaries (these may link against libc)
RUN gox \
				-arch="amd64" \
				-os="linux" \
				-output="dist/{{.OS}}_{{.Arch}}_{{.Dir}}" \
				-ldflags='-extldflags "-static" -s -w' \
				-tags='netgo' ./...
# docker binaries (these are prohibited to link against libc since they go in
# a scratch image)
# They are also compressed (upx) to make the docker images as small as possible
RUN mkdir -p /ddist/etc
RUN CGO_ENABLED=0 gox \
				-arch="amd64 arm64 arm" \
				-os="linux" \
				-output="/ddist/{{.OS}}_{{.Arch}}_{{.Dir}}" \
				-ldflags='-extldflags "-static" -s -w' \
				-tags='netgo' ./...
RUN upx /ddist/linux*



# This builds the irc image from build binaries stage output
FROM scratch as irc
ARG TARGETOS
ARG TARGETARCH
COPY --from=build /ddist/${TARGETOS}_${TARGETARCH}_irc /ircbot
COPY --from=build /ddist/etc /
ENTRYPOINT ["/ircbot"]



# This builds the notifyd image from build binaries stage output
FROM scratch as notifyd
ARG TARGETOS
ARG TARGETARCH
COPY --from=build /ddist/${TARGETOS}_${TARGETARCH}_notifyd /notifyd
COPY --from=build /ddist/etc /
ENTRYPOINT ["/notifyd"]



# This builds the input-webhook image from build binaries stage output
FROM scratch as input-webhook
ARG TARGETOS
ARG TARGETARCH
COPY --from=build /ddist/${TARGETOS}_${TARGETARCH}_input-webhook /input-webhook
COPY --from=build /ddist/etc /
# just the one port that accepts webhook connections from sabnzbd/sickrage/CouchPotato
EXPOSE 38475
ENTRYPOINT ["/input-webhook"]



# This builds the syncd image from build binaries stage output
# syncd runs a shell script to do the actual downloading, so can't use `scratch`
FROM alpine:3.12.0 as syncd
ARG TARGETOS
ARG TARGETARCH
COPY --from=build /ddist/${TARGETOS}_${TARGETARCH}_syncd /syncd
COPY --from=build /ddist/etc /
# COPY --from=build /go/src/github.com/iggy/scurvy/cmd/syncd/sync_files.sh /

# Need the ca-certificates for the NATS TLS cert and using rsync for the
# file sync for now
RUN apk --no-cache add rsync ca-certificates

# ENV SCURVY_BASE_URL "https://scurvy"
# ENV SCURVY_DL_DIR "/scurvy/"
# ENV SCURVY_COMPLETE_URL "scurvy/complete"
# Where all the files are stored
# VOLUME ["/scurvy"]
# The script to run when syncd gets a new download message
# If using rsync/ssh/etc, you'll need to also pass in ssh keys
# VOLUME ["/sync_files.sh"]