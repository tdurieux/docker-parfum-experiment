#----------------------------------------------------------------------------------------------
FROM redisfab/redis:6.2.6-x64-bullseye AS redis
FROM debian:bullseye-slim AS builder

RUN if [ -f /root/.profile ]; then sed -ie 's/mesg n/tty -s \&\& mesg -n/g' /root/.profile; fi
SHELL ["/bin/bash", "-l", "-c"]

RUN echo "Building for bullseye (debian:bullseye-slim) for x64 [with Redis 6.2.6]"

WORKDIR /build
COPY --from=redis /usr/local/ /usr/local/

ADD . /build

RUN ./deps/readies/bin/getupdates
RUN ./deps/readies/bin/getpy3
RUN ./sbin/system-setup.py

RUN /usr/local/bin/redis-server --version

RUN make build SHOW=1

#----------------------------------------------------------------------------------------------