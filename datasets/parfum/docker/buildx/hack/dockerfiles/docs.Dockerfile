# syntax=docker/dockerfile:1.4

ARG GO_VERSION=1.18
ARG FORMATS=md,yaml

FROM golang:${GO_VERSION}-alpine AS docsgen
WORKDIR /src
RUN --mount=target=. \
  --mount=target=/root/.cache,type=cache \
  go build -mod=vendor -o /out/docsgen ./docs/generate.go

FROM alpine AS gen
RUN apk add --no-cache rsync git
WORKDIR /src
COPY --from=docsgen /out/docsgen /usr/bin
ARG FORMATS
RUN --mount=target=/context \
  --mount=target=.,type=tmpfs <<EOT
set -e
rsync -a /context/. .
docsgen --formats "$FORMATS" --source "docs/reference"
mkdir /out
cp -r docs/reference /out
EOT

FROM scratch AS update
COPY --from=gen /out /out

FROM gen AS validate
RUN --mount=target=/context \
  --mount=target=.,type=tmpfs <<EOT
set -e
rsync -a /context/. .
git add -A
rm -rf docs/reference/*
cp -rf /out/* ./docs/
if [ -n "$(git status --porcelain -- docs/reference)" ]; then
  echo >&2 'ERROR: Docs result differs. Please update with "make docs"'
  git status --porcelain -- docs/reference
  exit 1
fi
EOT
