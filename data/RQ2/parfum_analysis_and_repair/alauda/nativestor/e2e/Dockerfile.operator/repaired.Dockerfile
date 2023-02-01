FROM ubuntu:20.04
RUN apt-get update && apt-get -y --no-install-recommends install gdisk udev lvm2 && rm -rf /var/lib/apt/lists/*;
COPY . /
ENTRYPOINT ["/topolvm"]