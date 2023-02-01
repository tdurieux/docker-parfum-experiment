FROM ubuntu:bionic

VOLUME /opt/melon
RUN apt-get update && apt-get install --no-install-recommends -y --force-yes cmake && apt-get install --no-install-recommends -y --force-yes build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y --force-yes libbsd-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y --force-yes gcc-multilib g++-multilib && rm -rf /var/lib/apt/lists/*;
RUN dpkg --add-architecture i386 && apt-get update
RUN apt-get update && apt-get install --no-install-recommends -y --force-yes libc6-dbg:i386 && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y --force-yes gdb && rm -rf /var/lib/apt/lists/*;
COPY melon_test.sh /usr/local/bin
CMD /usr/local/bin/melon_test.sh