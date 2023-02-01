FROM debian:sid
ADD sources.list /etc/apt/sources.list.d/sources.list
RUN apt update -y && apt install --no-install-recommends -y dpkg-dev && rm -rf /var/lib/apt/lists/*;
# this as a "macho-invalid" directory which is useful for testing
RUN apt-get source -y clang-13
