FROM alpine
LABEL maintainer="Fleet Developers <hello@fleetdm.com>"

RUN apk --update --no-cache add ca-certificates

# Create FleetDM group and user
RUN addgroup -S fleet && adduser -S fleet -G fleet

COPY ./build/binary-bundle/linux/fleet ./build/binary-bundle/linux/fleetctl /usr/bin/

USER fleet
CMD ["fleet", "serve"]
