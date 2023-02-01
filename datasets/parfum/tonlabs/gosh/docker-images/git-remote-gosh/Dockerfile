# syntax=docker/dockerfile:1.4

FROM --platform=${BUILDPLATFORM} node:16-slim as base

WORKDIR /
COPY gosh gosh
COPY git-remote-gosh git-remote-gosh

ENV NODE_ENV=production
RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt <<EOF
    set -ex
    apt-get update -qy
    apt-get install git ca-certificates -qy
    cd /git-remote-gosh
    npm ci
    chmod +x git-remote-gosh.js
    cd /usr/local/bin
    ln -s /git-remote-gosh/git-remote-gosh.js git-remote-gosh
EOF

WORKDIR /root
ENTRYPOINT [ "git" ]
CMD [ "" ]
