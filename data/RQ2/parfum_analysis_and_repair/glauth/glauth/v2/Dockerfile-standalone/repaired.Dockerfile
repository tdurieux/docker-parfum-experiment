#################
# Build Step
#################

FROM golang:alpine as build
LABEL maintainers="Ben Yanke <ben@benyanke.com>, Jörn Friedrich Dreyer <jfd@butonic.de>, Chris F Ravenscroft <chris@voilaweb.com>"

# Setup work env
RUN mkdir /app /tmp/gocode
ADD local/app /app/
WORKDIR /app/v2

# Required envs for GO
ENV GOPATH=/tmp/gocode
ENV GOOS=linux
ENV GOARCH=amd64
ENV CGO_ENABLED=0

# Only needed for alpine builds // also: busybox
RUN apk add --no-cache git make busybox-static dumb-init

# Install deps
RUN go get -d -v ./...

# Build and copy final result
RUN uname -a
RUN if [ $(uname -m) == x86_64 ]; then make linuxamd64 && cp ./bin/linuxamd64/glauth /app/v2/glauth; fi
RUN if [ $(uname -m) == aarch64 ]; then make linuxarm64 && cp ./bin/linuxarm64/glauth /app/v2/glauth; fi
RUN if [ $(uname -m) == armv7l ]; then make linuxarm && cp ./bin/linuxarm/glauth /app/v2/glauth; fi

# Check glauth works
RUN /app/v2/glauth --version

#################
# Run Step
#################

FROM gcr.io/distroless/base-debian10 as run
LABEL maintainers="Ben Yanke <ben@benyanke.com>, Jörn Friedrich Dreyer <jfd@butonic.de>, Chris F Ravenscroft <chris@voilaweb.com>"

# Copy binary from build container
COPY --from=build /app/v2/glauth /app/glauth

# Copy docker specific scripts from build container
COPY --from=build /app/v2/scripts/docker/start-standalone.sh /app/docker/
COPY --from=build /app/v2/scripts/docker/default-config-standalone.cfg /app/docker/

# Just what we need
COPY --from=build /usr/bin/dumb-init /usr/bin/dumb-init
COPY --from=build /bin/busybox.static /bin/sh
COPY --from=build /bin/busybox.static /bin/ln
COPY --from=build /bin/busybox.static /bin/rm
RUN ln /bin/sh /usr/bin/cp && ln /bin/sh /usr/bin/mkdir && rm /bin/ln /bin/rm

# Install init

# Expose web and LDAP ports