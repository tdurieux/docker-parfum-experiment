FROM alpine as build
MAINTAINER root@localhost

FROM scratch
MAINTAINER root@localhost
COPY --from=build / /
MAINTAINER root@localhost
COPY --from=build / /