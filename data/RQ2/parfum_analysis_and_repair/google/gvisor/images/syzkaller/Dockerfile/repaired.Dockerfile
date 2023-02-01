FROM gcr.io/syzkaller/env

# This image is mostly for investigating syzkaller crashes, so let's install
# developer tools.
RUN apt update --allow-releaseinfo-change && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y git vim strace gdb procps && rm -rf /var/lib/apt/lists/*;

WORKDIR  /syzkaller/gopath/src/github.com/google/syzkaller

RUN git init . && git remote add origin https://github.com/google/syzkaller && git fetch origin && git checkout origin/master && make

ENTRYPOINT ./bin/syz-manager --config /tmp/syzkaller/syzkaller.cfg
