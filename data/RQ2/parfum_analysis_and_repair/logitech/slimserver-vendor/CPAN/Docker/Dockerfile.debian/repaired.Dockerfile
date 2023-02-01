# adjust base image to whatever version you want to build with
FROM --platform=linux/amd64 debian:unstable

RUN apt-get update && apt-get install --no-install-recommends -y nasm make gcc g++ rsync patch libc-bin zlib1g-dev libgd-dev unzip perl bzip2 && rm -rf /var/lib/apt/lists/*;

RUN mkdir /cpan

CMD ["/bin/bash"]