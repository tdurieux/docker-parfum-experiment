FROM ustcmirror/base:debian
LABEL maintainer="Keyu Tao <taoky@ustclug.org>"
RUN apt update && apt install --no-install-recommends -y yum-utils createrepo python3 python3-requests && rm -rf /var/lib/apt/lists/*;
ADD tunasync /usr/local/lib/tunasync
ADD sync.sh /
