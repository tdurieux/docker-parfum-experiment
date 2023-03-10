FROM alpine:edge

# Update image
RUN apk update && apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing py3-pygithub

# Install github-release.py
ADD https://raw.githubusercontent.com/muttleyxd/github-release/master/github-release.py /usr/bin/github-release
RUN chmod 755 /usr/bin/github-release