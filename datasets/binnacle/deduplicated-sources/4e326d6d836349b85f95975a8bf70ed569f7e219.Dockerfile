FROM debian:stretch

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --no-install-recommends nettle-dev:i386 gcc gcc-multilib \
        make file wget netcat-traditional sqlite3 git ca-certificates ssh libcap-dev:i386

# Install ghr for GitHub Releases: https://github.com/tcnksm/ghr
RUN wget https://github.com/tcnksm/ghr/releases/download/v0.12.0/ghr_v0.12.0_linux_amd64.tar.gz && \
    tar -xzf ghr_*_linux_amd64.tar.gz && \
    mv ghr_*_linux_amd64/ghr /usr/bin/ghr

ENV CC "gcc -m32"
