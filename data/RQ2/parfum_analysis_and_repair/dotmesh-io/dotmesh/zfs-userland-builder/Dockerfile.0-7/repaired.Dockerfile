FROM ubuntu:bionic
RUN apt-get update
RUN apt-get install --no-install-recommends -y debootstrap && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -dy zfsutils-linux python3-minimal libssl1.1 && rm -rf /var/lib/apt/lists/*;
