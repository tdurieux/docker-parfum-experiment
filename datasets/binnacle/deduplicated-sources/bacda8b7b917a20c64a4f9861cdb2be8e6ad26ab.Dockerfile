# mir-runner build container (alpine version)
FROM alpine:3.4
RUN apk add --update --no-cache build-base linux-headers libnl3-dev libcap-ng-dev bison flex tar file coreutils
ADD ./src /src/runner
WORKDIR /src/runner
RUN make
CMD tar -czf - runner
