FROM debian:stretch
LABEL description="fsync test image" \
      version="1.0"

RUN apt-get -y update \
    && apt-get -y --no-install-recommends install build-essential dmsetup xfsprogs e2fsprogs jfsutils dosfstools btrfs-progs gcc make bash sudo wget ca-certificates && rm -rf /var/lib/apt/lists/*;

ADD fsync_test_setup.sh ./
