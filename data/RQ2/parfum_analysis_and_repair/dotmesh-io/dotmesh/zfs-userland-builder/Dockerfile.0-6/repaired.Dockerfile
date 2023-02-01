FROM ubuntu:artful
RUN apt-get update
RUN apt-get install --no-install-recommends -y debootstrap && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -dy zfsutils-linux python3-minimal && rm -rf /var/lib/apt/lists/*;
