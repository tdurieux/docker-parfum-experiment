#################
# Build Step
#################

FROM golang:buster as build
LABEL maintainers="Ben Yanke <ben@benyanke.com>, Jörn Friedrich Dreyer <jfd@butonic.de>, Chris F Ravenscroft <chris@voilaweb.com>"

# Setup work env
RUN mkdir /app /tmp/gocode
ADD local/app /app/
WORKDIR /app/v2

# Required envs for GO
ENV GOPATH=/tmp/gocode
ENV GOOS=linux
ENV GOARCH=amd64
ENV GO_ENABLED=1

# Only needed for alpine builds // also: busybox
RUN apt -qq update && apt -qq --no-install-recommends install -y git make build-essential busybox-static dumb-init && rm -rf /var/lib/apt/lists/*;

# Install deps
RUN go get -d -v ./...

# Build and copy final result
RUN uname -a
RUN uname -m
RUN bash -c '[[ $(uname -m) == x86_64 ]] && { make linuxamd64 && cp ./bin/linuxamd64/glauth /app/v2/glauth; make plugins_linux_amd64 && cp ./bin/linuxamd64/*.so /app/v2/; } || { true; }'
RUN bash -c '[[ $(uname -m) == aarch64 ]] && { make linuxarm64 && cp ./bin/linuxarm64/glauth /app/v2/glauth; make plugins_linux_arm64 && cp ./bin/linuxarm64/*.so /app/v2/; } || { true; }'
RUN ls -l /app/v2/bin/linuxamd64

# Check glauth works
RUN /app/v2/glauth --version

#################
# Run Step
#################

FROM gcr.io/distroless/base-debian10 as run
LABEL maintainers="Ben Yanke <ben@benyanke.com>, Jörn Friedrich Dreyer <jfd@butonic.de>, Chris F Ravenscroft <chris@voilaweb.com>"

# Copy binary from build container
COPY --from=build /app/v2/glauth /app/glauth
COPY --from=build /app/v2/*.so /app/

# Copy docker specific scripts from build container
COPY --from=build /app/v2/scripts/docker/start-plugins.sh /app/docker/
COPY --from=build /app/v2/scripts/docker/default-config-plugins.cfg /app/docker/
COPY --from=build /app/v2/scripts/docker/gl.db /app/docker/

# Just what we need
COPY --from=build /usr/bin/dumb-init /usr/bin/dumb-init
COPY --from=build /bin/busybox /bin/sh
COPY --from=build /bin/busybox /bin/ln
COPY --from=build /bin/busybox /bin/rm
# Debug env: COPY --from=build /bin/busybox /bin/busybox
RUN ln /bin/sh /usr/bin/cp && ln /bin/sh /usr/bin/mkdir && rm /bin/ln /bin/rm

# Install init

# Expose web and LDAP ports
EXPOSE 389 636 5555

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/bin/sh", "/app/docker/start-plugins.sh"]
