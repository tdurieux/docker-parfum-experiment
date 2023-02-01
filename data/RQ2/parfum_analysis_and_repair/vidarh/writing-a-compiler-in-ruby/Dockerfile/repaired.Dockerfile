# -*- sh -*-
FROM debian:unstable

# Needed to be able to run Valgrind on m32 binaries
RUN dpkg --add-architecture i386

RUN apt-get update && apt-get -y --no-install-recommends install ruby2.5 ruby2.5-dev rubygems build-essential wget curl strace gdb gcc-multilib jq valgrind libc6-dbg:i386 ruby-bundler && rm -rf /var/lib/apt/lists/*;

#RUN gem install -n /usr/bin bundler
RUN gem install -n /usr/bin rake

VOLUME ["/app"]

WORKDIR /app
