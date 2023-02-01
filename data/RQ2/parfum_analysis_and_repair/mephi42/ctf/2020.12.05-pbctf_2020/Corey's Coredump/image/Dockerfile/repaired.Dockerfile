FROM debian:bullseye
COPY sources.list /etc/apt/
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install dpkg-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y build-dep valgrind
RUN apt-get -y --no-install-recommends install libc6-dbg && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install procps && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install gdb && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install strace && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install less && rm -rf /var/lib/apt/lists/*;
