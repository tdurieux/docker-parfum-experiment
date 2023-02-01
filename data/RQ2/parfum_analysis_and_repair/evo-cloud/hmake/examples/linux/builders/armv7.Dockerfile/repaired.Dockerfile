FROM thewtex/cross-compiler-linux-armv7:latest
RUN apt-get -y update && apt-get -y --no-install-recommends install bc && apt-get -y clean && rm -rf /var/lib/apt/lists/*;
