# Build the drone executable on a x64 Linux host:
#
#     go build --ldflags '-extldflags "-static"' -o drone_static
#
#
# Alternate command for Go 1.4 and older:
#
#     go build -a -tags netgo --ldflags '-extldflags "-static"' -o drone_static
#
#
# Build the docker image:
#
#     docker build --rm=true -t drone/drone .

## Built from cloudnautique/drone fork on github.

FROM busybox
EXPOSE 8000
ADD contrib/docker/etc/nsswitch.conf /etc/

# Pulled from centurylin/ca-certs source.