# New build
FROM dynamicdevices/%%RESIN_MACHINE_NAME%%-debian-makespacelive:stretch-devel
MAINTAINER ajlennon@dynamicdevices.co.uk

ENV INITSYSTEM on

WORKDIR /usr/src/app

COPY scripts/start.sh .
COPY stream.py .

# Run wifi connect