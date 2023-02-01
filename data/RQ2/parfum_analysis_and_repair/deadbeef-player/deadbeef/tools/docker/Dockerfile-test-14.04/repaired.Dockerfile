FROM ubuntu:trusty

WORKDIR /usr/src/deadbeef
COPY docker-artifacts/x86_64/deadbeef-devel /usr/src/deadbeef

RUN apt-get -qq update && apt-get install --no-install-recommends -y -qq libgtk2.0-0 libasound2 libpulse0 libgtk-3-0 libdispatch0 && rm -rf /var/lib/apt/lists/*;

RUN timeout -k 20s 20s /usr/src/deadbeef/deadbeef > /usr/src/deadbeef/log.txt
RUN cat /usr/src/deadbeef/log.txt


